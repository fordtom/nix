{
  config,
  pkgs,
  ...
}: {
  # system.stateVersion = 6;

  # ids.gids.nixbld = 350;

  nixpkgs.config.allowUnfree = true;

  nix = {
    enable = true;
    settings.experimental-features = ["nix-command" "flakes"];
  };

  environment.shells = with pkgs; [bashInteractive];
  environment.systemPackages = with pkgs; [
    cachix
  ];
}
