This machine's agent configuration is maintained in the dotfiles repo at `~/config`.

Before editing Pi configuration, inspect `~/.pi/agent` for symlinks. Edit source files under `~/config/.pi/agent` instead of their linked paths.

Shared agent instructions live in `~/config/.codex/AGENTS.md`. Pi links to this file from `~/config/.pi/agent/AGENTS.md`.

Run `stow .` from `~/config` to manage these links.
