This machine's agent configuration is maintained from the dotfiles repo at `~/config`.

When editing Pi configuration, first inspect `~/.pi/agent` for symlinks and prefer editing the source files under `~/config/.pi/agent` rather than generated symlink targets.

Shared agent instructions generally live in `~/config/.agents/AGENTS.md`, which may be symlinked into tool-specific config locations.

Stow is managed by running `stow .` from `~/config`; do not use one-off individual-file stow commands.
