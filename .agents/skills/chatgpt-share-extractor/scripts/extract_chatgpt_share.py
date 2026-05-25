#!/usr/bin/env python3
"""Extract a markdown transcript from a public ChatGPT share page."""

from __future__ import annotations

import argparse
import json
import re
import urllib.error
import urllib.request
from dataclasses import dataclass
from pathlib import Path
from typing import Any


ENQUEUE_RE = re.compile(
    r"window\.__reactRouterContext\.streamController\.enqueue\((\".*?\")\);",
    re.DOTALL,
)
ENTITY_RE = re.compile(r"entity(\[.*?\])")


@dataclass
class Message:
    role: str
    text: str
    message_id: str | None = None
    create_time: float | None = None


@dataclass
class Conversation:
    title: str
    share_id: str | None
    url: str | None
    messages: list[Message]
    raw_message_count: int


def fetch(url: str) -> str:
    request = urllib.request.Request(
        url,
        headers={
            "User-Agent": (
                "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) "
                "AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125 Safari/537.36"
            )
        },
    )
    try:
        with urllib.request.urlopen(request, timeout=30) as response:
            return response.read().decode("utf-8", errors="replace")
    except urllib.error.URLError as exc:
        raise SystemExit(f"fetch failed: {exc}") from exc


def read_source(source: str) -> tuple[str, str | None]:
    if source.startswith("http://") or source.startswith("https://"):
        return fetch(source), source
    return Path(source).read_text(encoding="utf-8"), None


def extract_loader_table(html: str) -> list[Any]:
    for match in ENQUEUE_RE.finditer(html):
        payload = json.loads(match.group(1))
        if payload.startswith("["):
            table = json.loads(payload)
            if isinstance(table, list):
                return table
    raise SystemExit("no React Router loader payload found in share HTML")


def decode_compact_table(table: list[Any]) -> Any:
    memo: dict[int, Any] = {}
    in_progress: set[int] = set()

    def deref(index: int) -> Any:
        if index < 0:
            return None
        if index in memo:
            return memo[index]
        if index in in_progress:
            return None
        in_progress.add(index)
        value = decode(table[index])
        memo[index] = value
        in_progress.remove(index)
        return value

    def decode(value: Any) -> Any:
        if isinstance(value, dict):
            decoded: dict[Any, Any] = {}
            for key_ref, val_ref in value.items():
                key = deref(int(key_ref[1:])) if key_ref.startswith("_") else key_ref
                decoded[key] = deref(val_ref) if isinstance(val_ref, int) else decode(val_ref)
            return decoded
        if isinstance(value, list):
            return [deref(item) if isinstance(item, int) else decode(item) for item in value]
        return value

    return deref(0)


def find_share_data(decoded: dict[str, Any]) -> dict[str, Any]:
    loader_data = decoded.get("loaderData", {})
    route_data = loader_data.get("routes/share.$shareId.($action)", {})
    server_response = route_data.get("serverResponse", {})
    data = server_response.get("data")
    if not isinstance(data, dict):
        raise SystemExit("share loader payload did not contain serverResponse.data")
    return data


def clean_text(text: str) -> str:
    def replace_entity(match: re.Match[str]) -> str:
        try:
            value = json.loads(match.group(1))
        except json.JSONDecodeError:
            return match.group(0)
        if isinstance(value, list) and len(value) >= 2 and isinstance(value[1], str):
            return value[1]
        return match.group(0)

    return ENTITY_RE.sub(replace_entity, text).strip()


def message_text(content: dict[str, Any]) -> str:
    parts = content.get("parts")
    if not isinstance(parts, list):
        return ""
    text_parts = [part for part in parts if isinstance(part, str) and part.strip()]
    return clean_text("\n\n".join(text_parts))


def parse_conversation(source: str) -> Conversation:
    html, url = read_source(source)
    table = extract_loader_table(html)
    decoded = decode_compact_table(table)
    data = find_share_data(decoded)
    messages: list[Message] = []

    linear = data.get("linear_conversation") or []
    for node in linear:
        if not isinstance(node, dict):
            continue
        message = node.get("message")
        if not isinstance(message, dict):
            continue
        author = message.get("author") or {}
        content = message.get("content") or {}
        metadata = message.get("metadata") or {}
        role = author.get("role")
        text = message_text(content)
        if metadata.get("is_user_system_message"):
            continue
        if role not in {"user", "assistant"} or not text:
            continue
        messages.append(
            Message(
                role=role,
                text=text,
                message_id=message.get("id"),
                create_time=message.get("create_time"),
            )
        )

    return Conversation(
        title=data.get("title") or "ChatGPT Share",
        share_id=data.get("conversation_id"),
        url=url,
        messages=messages,
        raw_message_count=len(linear),
    )


def render_markdown(conversation: Conversation) -> str:
    lines = [f"# {conversation.title}", ""]
    if conversation.url:
        lines += [f"Source: {conversation.url}", ""]
    for message in conversation.messages:
        label = "User" if message.role == "user" else "Assistant"
        lines += [f"## {label}", "", message.text, ""]
    return "\n".join(lines).rstrip() + "\n"


def slugify(value: str) -> str:
    slug = re.sub(r"[^a-z0-9]+", "-", value.lower()).strip("-")
    return slug or "chatgpt-share"


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("source", help="ChatGPT share URL")
    parser.add_argument("out_dir", help="directory to write the markdown transcript into")
    args = parser.parse_args()

    conversation = parse_conversation(args.source)
    out_dir = Path(args.out_dir)
    out_dir.mkdir(parents=True, exist_ok=True)
    output = out_dir / f"{slugify(conversation.title)}.md"
    output.write_text(render_markdown(conversation), encoding="utf-8")
    print(output)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
