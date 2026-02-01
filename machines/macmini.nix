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

  programs.zsh.enable = true;
  programs.fish.enable = true;

  environment.shells = with pkgs; [bashInteractive zsh fish];

  environment.systemPackages = [
    pkgs.qmd
  ];
}
