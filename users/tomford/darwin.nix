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
      "helium-browser"
      "middleclick"
      "notion"
      "orbstack"
      "mullvad-vpn"
      "raycast"
      "signal"
      "spotify"
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
