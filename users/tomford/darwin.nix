{
  inputs,
  pkgs,
  ...
}: {
  homebrew = {
    enable = true;

    brews = [
      "mole"
    ];

    casks = [
      "1password"
      "aldente"
      "betterdisplay"
      "ghostty"
      "kitlangton-hex"
      "middleclick"
      "raycast"
      "spotify"
      "tailscale-app"
      "visual-studio-code"
    ];

    onActivation = {
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
