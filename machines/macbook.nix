{...}: {
  system.stateVersion = 6;

  ids.gids.nixbld = 350;

  nix = {
    enable = true;
    settings.experimental-features = ["nix-command" "flakes"];
  };
}
