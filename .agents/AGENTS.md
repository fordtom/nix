# Tom's agent instructions

This file, stowed at `~/.agents/AGENTS.md`, is the canonical entry point for agent-related documentation.

Conditionally read the following:

- [`~/.agents/MACHINES.md`](MACHINES.md) when working with my personal config or other machines on my tailnet (`macmini`/`macbook`/`pifive`).
- [`~/.agents/SUBAGENTS.md`](SUBAGENTS.md) before delegating work to another harness or model.
- [`~/.agents/WRITING.md`](WRITING.md) when writing or maintaining long-form prose, documentation, comments, or task trackers.

## Tools

### Executor

Executor is the default integration layer for tools and MCP servers. Start by loading its `execute` skill, then discover integrations and make calls through `executor_execute`.

Currently driven through executor:

- Parallel Web (search, fetch, crawling and web summaries)
- Cloudflare (full API for interacting with my projects)
- GitHub (most API routes for day-to-day development)

And more minor tooling - if you're looking for a tool/connection for something I mention then check here.

### CLIs

- `nix` is often used for toolchains => `nix develop -c` to run commands.
- `uv` for all Python => `uv run`, `uv venv`, `uv format`.
- `bun` for global npm packages.
- `fish` is my default login shell on most machines.
- `tmux` for persistent/interactive sessions (debugger/server).
- `trash` for deletes (macOS only).
- `op` holds all personal credentials; use `op run` (could hang for human authentication).
- `grepo` for managing external context within a repo; use `grepo skill` for usage (deprecated in `ds` managed repos, use `ds context` for the same functionality) (if you find a grepo/.lock repo, please move it to the new .repos/.lock approach that grepo supports so that migration to devspace is seamless).
- `gh` CLI for GitHub interaction on some machines - though Executor usage is preferred and works universally.

### Codex Specific Plugins

- use @Browser as the default for dev servers and other development work.
- use @Chrome (to drive Helium) as a fallback for @Browser or whenever you need to be logged in to my accounts.
- use @Computer for anything non-browser and/or a last resort for failures in the above 2 plugins.

## Communication

- Lead with the answer, decision, or required action. Follow with evidence and background.
- Bias towards [ASD-STE100 Simplified Technical English](https://www.asd-ste100.org/) as a baseline for communication style/prose.

## Agent protocol

- "Make a note" => terse `AGENTS.md`/`CLAUDE.md` edit (typically symlinked or @ referenced; prefer AGENTS as canonical).
- File drift over ~1000 LOC should be justified; split/refactor when appropriate and complexity doesn't suffer.
- New deps: quick health check (recent releases/commits, adoption).
- Always check/use repo’s package manager/runtime; no swaps w/o approval.
- Before handoff: run full gate (lint/typecheck/tests/docs).
- Always respect minimum release age rules on package managers.
- Split tasks by 2 categories; mechanical or opinionated. Opinionated tasks (APIs, product choices) warrant pre-implementation discussion, mechanical tasks (fix linter errors, known refactors) can be immediately greenlit.

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
- Keep test suite high signal and curated; a new test is not necessary with each change.
- Do not add tests which simply restate the implementation. These provide zero confidence.
- Do not preserve backwards compatibility unless explicitly requested.

## Philosophy

- "All code is technical debt" - every line has to earn its place, and we should strive to minimise bloat and inefficiency at every turn.
- Treat non-mainline code (branches or unstaged changes) as entirely malleable whilst we search for the ideal implementation.
