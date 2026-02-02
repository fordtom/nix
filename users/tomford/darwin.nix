{
  inputs,
  pkgs,
  ...
}: {
  homebrew = {
    enable = true;

    taps = [
      "steipete/tap"
    ];

    brews = [
      "mole"
      "steipete/tap/remindctl"
    ];

    casks = [
      "aldente"
      "betterdisplay"
      "claude"
      "ghostty"
      "middleclick"
      "orbstack"
      "mullvad-vpn"
      "raycast"
      "signal"
      "spotify"
      "steipete/tap/codexbar"
      "tailscale-app"
      "yubico-authenticator"
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
