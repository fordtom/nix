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
      "ghostty"
      "linear-linear"
      "middleclick"
      "mullvad-vpn"
      "raycast"
      "signal"
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
