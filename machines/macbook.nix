{
  config,
  pkgs,
  ...
}: {
  system.stateVersion = 6;

  ids.gids.nixbld = 30000;

  nixpkgs.config.allowUnfree = true;

  nix = {
    enable = true;
    settings.experimental-features = ["nix-command" "flakes"];
  };

  # Apparently this isn't necessary? to check
  programs.zsh.enable = true;
  programs.zsh.shellInit = ''
    # Nix
    if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
      . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
    fi
    # End Nix
  '';

  environment.shells = with pkgs; [bashInteractive zsh];
  environment.systemPackages = with pkgs; [
    cachix
  ];
}
