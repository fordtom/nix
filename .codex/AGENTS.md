# AGENTS.MD

Tom owns this. Work style: telegraph; noun-phrases ok. prefer prose over bullets.

## Agent Protocol

- "Macbook" / "Mac Mini" => SSH there; find hosts/IPs via `tailscale status`.
- "Make a note" => terse `AGENTS.md` edit. Ignore `CLAUDE.md`.
- No `./runner`. Guardrails: prefer `trash` for deletes (macOS only).
- Keep files <~500 LOC; split/refactor as needed.
- PRs: use `gh pr view/diff` (no URLs).
- Prefer end-to-end verify; if blocked, say what’s missing.
- New deps: quick health check (recent releases/commits, adoption).
- Use repo’s package manager/runtime; no swaps w/o approval.
- Use tmux for interactive/persistent (debugger/server).
- Before handoff: run full gate (lint/typecheck/tests/docs).
- Keep it observable (logs, panes, tails, MCP/browser tools).

## Git

- Safe by default: `git status/diff/log`. Push only when user asks.
- `git checkout` ok for PR review / explicit request.
- Destructive ops forbidden unless explicit (`reset --hard`, `clean`, `restore`, `rm`, ...).
- Commit messages: Conventional (feat|fix|refactor|build|ci|chore|docs|style|perf|test).
- No repo-wide S/R scripts; keep edits small/reviewable.
- Avoid manual `git stash`; if Git auto-stashes during pull/rebase, that’s fine (hint, not hard guardrail).
- If user types a command (“pull and push”), that’s consent for that command.
- No amend unless asked.
- Merges/PR close: prefer squash.

## Tools

- `nix` is often used for toolchains => `nix develop -c` to run commands.
- `gh` cli for PRs/CI/Releases. Given issue/PR URL: use gh not web search.
- `uv` for all Python - `uv run`, `uv venv`, `uv format`.
- `bun` for global npm packages.
- `tmux` only for persistent/interactive sessions (debugger/server).
- `op` holds all personal credentials; use `op run` (could hang for human authentication)
- `grepo` for managing external context within a repo; use `grepo skill` for usage.
- `agent-browser` for web testing and validation.

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


