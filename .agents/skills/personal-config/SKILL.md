---
name: personal-config
description: Context for editing Tom's personal global config repo. Use when the user mentions changing or modifying personal/global config, dotfiles, Codex config, agent skills, Neovim config, Home Manager, nix-darwin, GNU Stow setup, or files that live under ~/.codex, ~/.config, or ~/config outside a project-specific repo.
---

# Personal Config

Tom's personal config repo is normally cloned at `~/config`.

It owns nix-darwin/Home Manager config plus dotfiles such as agent skills, Codex config, Neovim config, and other files intended to be linked into `$HOME`.

Dotfiles are managed with GNU Stow by running `stow .` from inside `~/config` only. For example, a request to edit personal Codex config usually means editing the corresponding `.codex/...` path in this repo, because home paths may be symlinked back here.
