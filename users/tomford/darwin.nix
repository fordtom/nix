{
  inputs,
  pkgs,
  ...
}: {
  homebrew = {
    enable = true;
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
