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
      "chatgpt"
      "codex-app"
      "ghostty"
      "helium-browser"
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
      upgrade = true;
      cleanup = "zap";
      extraFlags = [
        "--force-cleanup" # Needed because leaving brew autoupdate on was a mistake
      ];
    };
  };

  security.pam.services.sudo_local.touchIdAuth = true;

  users.users.tomford = {
    home = "/Users/tomford";
    shell = pkgs.fish;
  };

  system.primaryUser = "tomford";
}
