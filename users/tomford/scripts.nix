{
  pkgs,
  lib,
}: {
  cliInstall = let
    bunGlobalPackages = [
      "@anthropic-ai/claude-code"
      "@ast-grep/cli"
      "@openai/codex"
      "@sourcegraph/amp"
      "@withgraphite/graphite-cli@stable"
      "jscpd"
    ];
  in
    pkgs.writeShellScriptBin "cli-install" ''
      bun add -g ${lib.concatStringsSep " " bunGlobalPackages}
    '';

  jgts = pkgs.writeShellScriptBin "jgts" ''
    set -euo pipefail

    # Push current JJ change, capture output
    if ! out="$(jj git push -c @ 2>&1)"; then
      printf '%s\n' "$out" >&2
      exit 1
    fi

    printf '%s\n' "$out"

    # First line should look like:
    #   "Creating bookmark push-<id> for revision <id>"
    first_line="$(printf '%s\n' "$out" | head -n1)"

    if ! printf '%s\n' "$first_line" | grep -q '^Creating '; then
      echo "Could not recognise jj git push output:" >&2
      printf '%s\n' "$first_line" >&2
      exit 1
    fi

    # Extract the bookmark/branch name (3rd field)
    branch="$(printf '%s\n' "$first_line" | awk '{print $3}')"

    if [ -z "$branch" ]; then
      echo "Failed to parse branch name from jj git push output" >&2
      exit 1
    fi

    echo "Using branch: $branch"

    # Wire the branch into Graphite (no prompts)
    gt track "$branch" --no-interactive 2>/dev/null || true

    # Submit this branch/stack, non-interactive, and publish immediately
    gt submit \
      --branch "$branch" \
      --stack \
      --no-edit \
      --no-interactive \
      --publish
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
