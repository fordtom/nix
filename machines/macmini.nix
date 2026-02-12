{
  config,
  pkgs,
  ...
}: let
  home = "/Users/tomford";
  stateDir = "${home}/.openclaw";
  openclaw = "${home}/.bun/bin/openclaw";
  gatewayPath = [
    "${home}/.nix-profile/bin"
    "/etc/profiles/per-user/tomford/bin"
    "/run/current-system/sw/bin"
    "/nix/var/nix/profiles/default/bin"
    "${home}/.bun/bin"
    "${home}/.local/bin"
    "/opt/homebrew/bin"
    "/usr/local/bin"
    "/usr/bin"
    "/bin"
    "/usr/sbin"
    "/sbin"
  ];
in {
  system.stateVersion = 6;

  ids.gids.nixbld = 350;

  nix = {
    enable = true;
    settings.experimental-features = ["nix-command" "flakes"];
  };

  programs.zsh.enable = true;
  programs.fish.enable = true;

  environment.shells = with pkgs; [bashInteractive zsh fish];

  environment.systemPackages = [
    pkgs.monitor-cli
    pkgs.qmd
  ];

  launchd.user.envVariables.PATH = gatewayPath;

  launchd.user.agents.openclaw-gateway = {
    path = gatewayPath;
    environment = {
      OPENCLAW_STATE_DIR = stateDir;
      OPENCLAW_CONFIG_PATH = "${stateDir}/openclaw.json";
    };
    serviceConfig = {
      Label = "ai.openclaw.gateway";
      RunAtLoad = true;
      KeepAlive = true;
      WorkingDirectory = home;
      StandardOutPath = "${stateDir}/logs/gateway.log";
      StandardErrorPath = "${stateDir}/logs/gateway.err.log";
      ProgramArguments = [
        openclaw
        "gateway"
        "run"
        "--bind"
        "tailnet"
        "--port"
        "18789"
        "--force"
      ];
    };
  };
}
