# Tom's agent instructions

This file, stowed at `~/.agents/AGENTS.md`, is the canonical entry point for agent-related documentation.

Read these when relevant:

- [`~/.agents/TOOLS.md`](TOOLS.md) for tools, package managers and executor usage.
- [`~/.agents/SUBAGENTS.md`](SUBAGENTS.md) before delegating work to another harness or model.

## Agent protocol

- "Macbook" / "Mac Mini" / "Pi" => SSH there; find hosts/IPs via `tailscale status`.
- "Make a note" => terse `AGENTS.md`/`CLAUDE.md` edit (typically symlinked or @ referenced; prefer AGENTS as canonical).
- File drift over ~1000 LOC should be justified; split/refactor when appropriate and complexity doesn't suffer.
- New deps: quick health check (recent releases/commits, adoption).
- Always check/use repo’s package manager/runtime; no swaps w/o approval.
- Before handoff: run full gate (lint/typecheck/tests/docs).
- Always respect minimum release age rules on package managers.

## VCS

- Three surfaces in the wild: git (most repos), jj (`.jj/`, jj CLI works), devspace (`.jj/` but ran through `ds`).
- jj/ds checkouts behave like jj but through different CLIs; same commit-message conventions. Remember to name changes.
- ds checkouts throw errors with the jj CLI. If you find one: run `ds skill` to get started.
- Safe by default: `status/diff/log`.
- `checkout` ok for PR review / explicit request.
- Destructive ops forbidden unless explicit (`reset --hard`, `clean`, `restore`, `rm`, ...).
- Commit messages: Conventional (feat|fix|refactor|build|ci|chore|docs|style|perf|test).
- No amend unless asked.
- Merges/PR close: prefer squash.
- Prefer repo clone via ssh.

## Repo health

- Delete dead files; do not leave stub modules.
- Prune todo lists rather than marking items as done.
- Comments/docs must only reflect present state rather than historical delta. Git is for history, docs are not.
- Keep test suite high signal and curated; a new test is not necessary with each change.
- Do not add tests which simply restate the implementation. These provide zero confidence.
- Do not preserve backwards compatibility unless explicitly requested.

## Philosophy

- "All code is technical debt" - every line has to earn its place, and we should strive to minimise bloat and inefficiency at every turn.
- Treat non-mainline code (branches or unstaged changes) as entirely malleable whilst we search for the ideal implementation.
