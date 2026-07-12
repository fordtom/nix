# Tom's AGENTS.md

## Agent Protocol

- "Macbook" / "Mac Mini" / "Pi" => SSH there; find hosts/IPs via `tailscale status`.
- "Make a note" => terse `AGENTS.md`/`CLAUDE.md` edit (typically symlinked or @ referenced; prefer AGENTS as canonical).
- file drift over ~1000 LOC should be justified; split/refactor when appropriate and complexity doesn't suffer.
- New deps: quick health check (recent releases/commits, adoption).
- Always check/use repo’s package manager/runtime; no swaps w/o approval.
- Before handoff: run full gate (lint/typecheck/tests/docs).
- Always respect minimum release age rules on package managers.

## VCS

- Three surfaces in the wild: git (most repos), jj (`.jj/`, jj CLI works), devspace (`.jj/` but ran through `ds`).
- jj/ds checkouts behave like jj but through different CLIs; same commit-message conventions. remember to name changes.
- ds checkouts throw errors with the jj CLI. If you find one: run `ds skill` to get started.
- Safe by default: `status/diff/log`.
- `checkout` ok for PR review / explicit request.
- Destructive ops forbidden unless explicit (`reset --hard`, `clean`, `restore`, `rm`, ...).
- Commit messages: Conventional (feat|fix|refactor|build|ci|chore|docs|style|perf|test).
- No amend unless asked.
- Merges/PR close: prefer squash.
- Prefer repo clone via ssh.

## Tools

- `nix` is often used for toolchains => `nix develop -c` to run commands.
- `gh` cli for GitHub interaction, reading issues, opening/closing PRs etc. `@GitHub` plugin (Codex) if gh auth is missing.
- `uv` for all Python => `uv run`, `uv venv`, `uv format`.
- `pnpm` for global npm packages.
- `fish` is my default login shell on most machines.
- `tmux` for persistent/interactive sessions (debugger/server).
- `trash` for deletes (macOS only).
- `op` holds all personal credentials; use `op run` (could hang for human authentication)
- `grepo` for managing external context within a repo; use `grepo skill` for usage (deprecated in `ds` managed repos, use `ds context` for same functionality).

## Orchestration

Consider the following table:

| model         | cost | intelligence | taste |
|---------------|------|--------------|-------|
| gpt-5.6-sol   | 8    | 9            | 7     |
| gpt-5.6-terra | 9    | 7            | 6     |
| gpt-5.6-luna  | 10   | 6            | 5     |
| opus-4.8      | 6    | 7            | 8     |
| fable-5       | 4    | 9            | 9     |
| grok-4.5      | 7    | 6            | 7     |

- Rankings, higher = better. Cost reflects how much I actually pay for subscriptions.
- Intelligence covers how hard a problem the model can solve unsupervised; taste covers UI/UX, code quality, API design and copy.
- These are defaults/suggestions, not hard limits.
- Judge the output not the price tag; rerun with smarter models if the quality bar isn't met.
- Cost is a tie-breaker only; pick from intelligence/taste depending on the task.
- Bulk/mechanical work -> gpt-5.6 sol|terra.
- User-facing (UI, copy) needs taste >= 7.
- Mechanics: `codex exec` and `codex review` via CLI if you are Claude. `claude -p` via CLI if you are Codex. `grok -p` wraps the cursor cli.
- Prefer your built in harness subagent tools for models from your own family (e.g. Fable calling Opus, or Sol calling Terra).
- Don't override sandbox/permissions defaults unless you explicitly want read-only.

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
