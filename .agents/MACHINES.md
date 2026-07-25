# Machines and personal configuration

`~/config` is the source for my nix-darwin and Home Manager configuration, plus dotfiles for agents, shells, Neovim and other tools.

Home paths can be symlinks into this checkout. Edit the source under `~/config`, then run `stow .` from that directory when links need updating.

The 3 maintained computers are:

- `macbook`: primary Apple silicon Mac
- `macmini`: remote Apple silicon Mac
- `pifive`: Raspberry Pi 5 running Ubuntu

access via ssh over Tailscale => use `tailscale status` for hosts/IPs.

Both Macs use the nix-darwin outputs in this repo, with shared user configuration in `users/tomford/home-manager.nix`. The Pi has Nix for project environments and builds. It does not use NixOS or Home Manager.

When editing machine nix configs leave the rebuild/application step to me (for review and sudo). Project flakes are fine to edit/run.

