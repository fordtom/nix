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
      "middleclick"
      "notion"
      "mullvad-vpn"
      "raycast"
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
