# Tools

- Executor is the default integration layer for tools and MCP servers. Start by loading its `execute` skill, then discover integrations and make calls through `executor_execute`; resume paused calls rather than starting them again.
- Prefer executor's sandbox for integration code and intermediate data instead of pulling large tool outputs into the agent context.
- `nix` is often used for toolchains => `nix develop -c` to run commands.
- `gh` CLI for GitHub interaction, reading issues, opening/closing PRs etc. Use Executor or the `@GitHub` plugin if gh auth is missing.
- `uv` for all Python => `uv run`, `uv venv`, `uv format`.
- `bun` for global npm packages.
- `fish` is my default login shell on most machines.
- `tmux` for persistent/interactive sessions (debugger/server).
- `trash` for deletes (macOS only).
- `op` holds all personal credentials; use `op run` (could hang for human authentication).
- `grepo` for managing external context within a repo; use `grepo skill` for usage (deprecated in `ds` managed repos, use `ds context` for the same functionality).
- Computer use: try @browser for dev work; @chrome as a fallback or for anything that needs a login, then @computer for non-browser or last resort.
