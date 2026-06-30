{
  inputs,
  pkgs,
  ...
}: {
  homebrew = {
    enable = true;

    brews = [
      "herdr"
      "mole"
    ];

    casks = [
      "1password"
      "aldente"
      "betterdisplay"
      "chatgpt"
      "codex-app"
      "cursor"
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
      cleanup = "none";
      extraFlags = [
        # TODO: Check if nix-darwin stable handles Homebrew cleanup without deprecated flags.
        "--force-cleanup"
        "--zap"
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
