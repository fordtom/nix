{
  inputs,
  pkgs,
  ...
}: {
  homebrew = {
    enable = true;

    taps = [
      "withgraphite/tap"
    ];

    brews = [
      "withgraphite/tap/graphite"
    ];

    casks = [
      "aldente"
      "betterdisplay"
      "claude"
      "container"
      "discord"
      "ghostty"
      "linear-linear"
      "middleclick"
      "mullvad-vpn"
      "notion"
      "raycast"
      "signal"
      "slack"
      "spotify"
      "tailscale-app"
      "yubico-yubikey-manager"
    ];

    onActivation = {
      autoUpdate = true;
      upgrade = true;
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
