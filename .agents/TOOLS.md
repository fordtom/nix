# Tools

## Executor

Executor is the default integration layer for tools and MCP servers. Start by loading its `execute` skill, then discover integrations and make calls through `executor_execute`; resume paused calls rather than starting them again.

Currently driven through executor:

- Parallel Web (search, fetch, crawling and web summaries)
- Cloudflare (full API for interacting with my projects)
- GitHub (most API routes for day-to-day development)

And more minor tooling - if you're looking for a tool/connection for something I mention then check here.

## CLIs

- `nix` is often used for toolchains => `nix develop -c` to run commands.
- `gh` CLI for GitHub interaction, reading issues, opening/closing PRs etc. Use Executor or the `@GitHub` plugin if gh auth is missing.
- `uv` for all Python => `uv run`, `uv venv`, `uv format`.
- `bun` for global npm packages.
- `fish` is my default login shell on most machines.
- `tmux` for persistent/interactive sessions (debugger/server).
- `trash` for deletes (macOS only).
- `op` holds all personal credentials; use `op run` (could hang for human authentication).
- `grepo` for managing external context within a repo; use `grepo skill` for usage (deprecated in `ds` managed repos, use `ds context` for the same functionality) (if you find a grepo/.lock repo, please move it to the new .repos/.lock approach that grepo supports so that migration to devspace is seamless).

## Codex Specific Plugins

- use @Browser as the default for dev servers and other development work.
- use @Chrome (to drive Helium) as a fallback for @Browser or whenever you need to be logged in to my accounts.
- use @Computer for anything non-browser and/or a last resort for failures in the above 2 plugins.

