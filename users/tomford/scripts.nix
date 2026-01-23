{
  pkgs,
  lib,
}: {
  bunInstall = let
    bunGlobalPackages = [
      "@ast-grep/cli"
      "@openai/codex"
      "jscpd"
      "agent-browser"
      "knip"
    ];
  in
    pkgs.writeShellScriptBin "bun-install" ''
      bun add -g ${lib.concatStringsSep " " bunGlobalPackages}
    '';

  cliInstall = pkgs.writeShellScriptBin "cli-install" ''
    curl -fsSL https://ampcode.com/install.sh | bash
    curl -fsSL https://claude.ai/install.sh | bash
    curl -fsSL https://opencode.ai/install | bash
  '';

  pinguAsk = pkgs.writeShellScriptBin "ask" ''
    set -euo pipefail

    if [[ $# -lt 1 ]]; then
      echo "Usage: pingu <question>" >&2
      exit 1
    fi

    TEXT="$1"
    CWD="$(pwd)"

    response=$(curl -s -w "\n%{http_code}" \
      -X POST \
      -H "Content-Type: application/json" \
      -d "$(jq -n --arg text "$TEXT" --arg cwd "$CWD" '{text: $text, cwd: $cwd}')" \
      "$PINGU_URL/ask") || {
      echo "Failed to reach Pingu server at $PINGU_URL" >&2
      exit 1
    }

    body=$(echo "$response" | sed '$d')
    status=$(echo "$response" | tail -n1)

    case "$status" in
      200)
        echo "$body"
        exit 0
        ;;
      504)
        echo "Timed out waiting for answer" >&2
        exit 1
        ;;
      503)
        echo "Server unavailable" >&2
        exit 1
        ;;
      *)
        echo "Error ($status): $body" >&2
        exit 1
        ;;
    esac
  '';
}
