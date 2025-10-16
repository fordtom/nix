{
  inputs,
  pkgs,
  ...
}: {
  homebrew = {
    enable = true;
    casks = [
      "1password"
      "claude"
      "container"
      "discord"
      "ghostty"
      "google-chrome"
      "linear-linear"
      "middleclick"
      "mullvad-vpn"
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
