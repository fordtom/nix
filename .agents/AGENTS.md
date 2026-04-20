# AGENTS.MD

Tom owns this. Work style: telegraph; noun-phrases ok. prefer prose over bullets.

## Agent Protocol

- "Macbook" / "Mac Mini" => SSH there; find hosts/IPs via `tailscale status`.
- "Make a note" => edit `AGENTS.md` (shortcut; not a blocker). Ignore `CLAUDE.md`.
- No `./runner`. Guardrails: prefer `trash` for deletes (macOS only).
- Keep files <~500 LOC; split/refactor as needed.
- Commit messages: Conventional (feat|fix|refactor|build|ci|chore|docs|style|perf|test).
- PRs: use `gh pr view/diff` (no URLs).
- Prefer end-to-end verify; if blocked, say what’s missing.
- New deps: quick health check (recent releases/commits, adoption).
- Web: search early; quote exact errors; prefer 2026 sources.

## Flow & Runtime

- Use repo’s package manager/runtime; no swaps w/o approval.
- Use Codex background for long jobs; tmux only for interactive/persistent (debugger/server).
- Subagents => use regularly for verifiable/parallelable chunks of work or one-off forks in the task.
- Before handoff: run full gate (lint/typecheck/tests/docs).
- Keep it observable (logs, panes, tails, MCP/browser tools).

## Git

- Safe by default: `git status/diff/log`. Push only when user asks.
- `git checkout` ok for PR review / explicit request.
- Destructive ops forbidden unless explicit (`reset --hard`, `clean`, `restore`, `rm`, ...).
- No repo-wide A/R scripts; keep edits small/reviewable.
- Avoid manual `git stash`; if Git auto-stashes during pull/rebase, that’s fine (hint, not hard guardrail).
- If user types a command (“pull and push”), that’s consent for that command.
- No amend unless asked.
- Big review: `git --no-pager diff --color=never`.
- Merges/PR close: prefer squash.

## Critical Thinking

- Fix root cause (not band-aid).
- Unsure: read more code; if still stuck, ask w/ short options.
- Conflicts: call out; pick safer path.
- Unrecognized changes: assume other agent; keep going; focus your changes. If it causes issues, stop + ask user.
- Leave breadcrumb notes in thread.

## Tools

- `nix` is used for toolchains in some projects. use `nix develop -c` to run commands. Do not modify nix files without approval.
- `gh` cli for PRs/CI/Releases. Given issue/PR URL: use gh not web search.
- `uv` for all Python usage - `uv run`, `uv venv`, `uv format`.
- `nu` nushell is the preferred tool for small/medium-scale adhoc data manipulation.
- `bun` for global npm packages.
- `agent-browser` for browser automation/testing.
- `tmux` only for persistenct/interactive sessions (debugger/server).
- `op` holds all personal credentials; e.g. for publishing use `op run` (could hang for human authentication)
- `grepo` for managing external context within a repo; use `grepo skill` for usage.

## Repo Health

- Delete dead files; do not leave stub modules.
- prune todo-lists rather than overwriting as done.
- Comments/docs must only reflect present state rather than historical delta. git is for history, not code.
- Keep test suite high signal and curated; a new test is not necessary with each change.
- Treat non-mainline code (branches or unstaged changes) as entirely throwaway and malleable.
- Do not preserve backwards compatibility unless explicitly requested.

