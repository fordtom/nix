{
  inputs,
  pkgs,
  ...
}: {
  homebrew = {
    enable = true;

    brews = [
      "mole"
      "vite-plus"
      {
        name = "node";
        link = false;
      }
    ];

    casks = [
      "1password"
      "aldente"
      "betterdisplay"
      "ghostty"
      "kitlangton-hex"
      "middleclick"
      "raycast"
      "signal"
      "spotify"
      "tailscale-app"
      "visual-studio-code"
    ];

    onActivation = {
      autoUpdate = true;
      upgrade = false;
      cleanup = "zap";
    };
  };

  security.pam.services.sudo_local.touchIdAuth = true;

  users.users.tomford = {
    home = "/Users/tomford";
    shell = pkgs.fish;
  };

  system.primaryUser = "tomford";
}
