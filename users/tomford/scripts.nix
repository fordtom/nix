{
  pkgs,
  lib,
}: {
  bunInstall = let
    bunGlobalPackages = [
      "@openai/codex"
      "jscpd"
      "agent-browser"
      "knip"
      "btca"
    ];
  in
    pkgs.writeShellScriptBin "bun-install" ''
      bun add -g ${lib.concatStringsSep " " bunGlobalPackages}
    '';

  cliInstall = pkgs.writeShellScriptBin "cli-install" ''
    curl -fsSL https://ampcode.com/install.sh | bash
    curl -fsSL https://opencode.ai/install | bash
  '';
}
