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
      "1password"
      "aldente"
      "betterdisplay"
      "claude"
      "ghostty"
      "helium-browser"
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
    };
  };

  security.pam.services.sudo_local.touchIdAuth = true;

  users.users.tomford = {
    home = "/Users/tomford";
    shell = pkgs.fish;
  };

  system.primaryUser = "tomford";
}
