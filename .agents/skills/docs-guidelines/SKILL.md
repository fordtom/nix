---
name: docs-guidelines
description: Maintain repo documentation and markdown trackers so they stay concise, current, and authoritative. Use when Codex edits or reviews `README.md`, `AGENTS.md`, `docs/*.md`, onboarding notes, code comments, `todo.md`, `dev/todos.md`, PR cleanup docs, or other markdown guidance/task files, especially after technical changes, migrations, deprecations, or drift cleanup. Enforce open-items-only trackers, current-state-only docs/comments, canonical-source examples, and deletion of obsolete duplicate notes/specs.
---

# Docs Guidelines

## Overview

Apply these rules whenever a task includes repo docs, markdown trackers, or code comments.
Keep durable documentation focused on present truth. Keep task lists focused on unfinished work.

## Classify The File First

- Treat `todo.md`, checklists, and backlog markdown as open-work trackers. Keep only still-open items.
- Treat `README.md`, `AGENTS.md`, `docs/*.md`, onboarding notes, and similar docs as current-state references. Document only how the repo works now.
- Treat code comments the same way as durable docs. Explain current behavior, current constraints, or still-open follow-up work.
- Treat scratch notes, implementation-only specs, migration notes, or one-off hardening docs as temporary unless the repo still actively needs them. Delete them once durable docs absorb the surviving guidance.

## Apply The Core Rules

- Remove completed tracker items instead of marking them done. Do not leave `[x]`, `done`, `completed`, or struck-through items in task lists. Git history is the record of completed work.
- Prune stale tracker items while you are there. If an item is no longer actionable or no longer relevant, remove it rather than preserving dead backlog text.
- Write durable docs and comments in present tense, as current truth.
- Remove historical phrasing such as `now`, `no longer`, `previously`, `used to`, `after the migration`, or `was renamed from` unless the history itself is the subject of the document.
- Do not turn docs into changelogs. The diff/PR/history explains what changed; the document should explain what is true.
- Prefer one authoritative description over parallel overlapping docs. If an old spec, scratch note, or duplicate guide is superseded, delete it.
- Keep examples synced to the canonical artifact that actually drives behavior: code, schema, config, or real command output. Do not hand-maintain example shapes when an authoritative source exists.
- When behavior changes, update all durable surfaces in the same pass: user-facing docs, AGENTS guidance, comments, examples, and trackers that still mention future work.

## Use Canonical Sources

- Read the code/config/example file that actually defines the contract before editing prose.
- If a README example is derived from a canonical config or command, regenerate it from the canonical source instead of paraphrasing from memory.
- Refresh authoritative docs first when a later task depends on them, such as parity review or gap analysis. Do not analyze against stale docs.
