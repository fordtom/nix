{
  config,
  pkgs,
  ...
}: {
  system.stateVersion = 6;

  ids.gids.nixbld = 350;

  nix = {
    enable = true;
    settings.experimental-features = ["nix-command" "flakes"];
  };

  environment.shells = with pkgs; [bashInteractive zsh];
  environment.systemPackages = with pkgs; [
    cachix
  ];
}
