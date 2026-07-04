# AGENTS.MD

Tom owns this. Work style: telegraph; noun-phrases ok. prefer prose over bullets.

## Agent Protocol

- "Macbook" / "Mac Mini" => SSH there; find hosts/IPs via `tailscale status`.
- "Make a note" => terse `AGENTS.md` edit. Ignore `CLAUDE.md`.
- No `./runner`. Guardrails: prefer `trash` for deletes (macOS only).
- file drift over ~1000 LOC should be justified; split/refactor when appropriate and complexity doesn't suffer.
- Prefer end-to-end verify; if blocked, say what’s missing.
- New deps: quick health check (recent releases/commits, adoption).
- Always check/use repo’s package manager/runtime; no swaps w/o approval.
- Use tmux for interactive/persistent (debugger/server).
- Before handoff: run full gate (lint/typecheck/tests/docs).
- Keep it observable (logs, panes, tails, MCP/browser tools).
- Always respect minimum release age rules on package managers.

## VCS

- Three surfaces in the wild: git (most repos), jj (`.jj/`, jj CLI works), devspace (`.jj/` but ran through `ds`).
- jj/ds checkouts behave like jj but through different CLIs; same commit-message conventions. remember to name changes.
- ds checkouts throw errors with the jj CLI. If you find one: always read the devspace skill, and work in the change/workspace you've been given.
- Safe by default: `status/diff/log`.
- `checkout` ok for PR review / explicit request.
- Destructive ops forbidden unless explicit (`reset --hard`, `clean`, `restore`, `rm`, ...).
- Commit messages: Conventional (feat|fix|refactor|build|ci|chore|docs|style|perf|test).
- No repo-wide S/R scripts; keep edits small/reviewable.
- Avoid manual `stash`; if Git auto-stashes during pull/rebase, that’s fine (hint, not hard guardrail).
- No amend unless asked.
- Merges/PR close: prefer squash.
- Prefer repo clone via ssh.

## Tools

- `nix` is often used for toolchains => `nix develop -c` to run commands.
- `uv` for all Python - `uv run`, `uv venv`, `uv format`.
- `pnpm` for global npm packages.
- `tmux` only for persistent/interactive sessions (debugger/server).
- `op` holds all personal credentials; use `op run` (could hang for human authentication)
- `grepo` for managing external context within a repo; use `grepo skill` for usage (deprecated in `ds` managed repos, use `ds context` for same functionality).

## Repo Health

- Delete dead files; do not leave stub modules.
- prune todo-lists rather than overwriting as done.
- Comments/docs must only reflect present state rather than historical delta. git is for history, docs are not.
- Keep test suite high signal and curated; a new test is not necessary with each change.
- Do not add tests which simply restate the implementation. These provide zero confidence.
- Do not preserve backwards compatibility unless explicitly requested.

## Philosophy

- "All code is technical debt" - every line has to earn its place, and we should strive to minimise bloat and inefficiency at every turn.
- Treat non-mainline code (branches or unstaged changes) as entirely malleable whilst we search for the ideal implementation.

