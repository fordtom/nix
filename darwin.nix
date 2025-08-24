{
  inputs,
  pkgs,
  ...
}: {
  homebrew = {
    enable = true;
    casks = [
      "discord"
      "middleclick"
      "spotify"
      "yubico-yubikey-manager"
    ];

    onActivation = {
      autoUpdate = true;
      upgrade = true;
    };
  };

  security.pam.services.sudo_local.touchIdAuth = true;

  users.users.tomford = {
    home = "/Users/tomford";
    shell = pkgs.zsh;
  };

  system.primaryUser = "tomford";
}
