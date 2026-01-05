{inputs, ...}: {
  config,
  lib,
  pkgs,
  ...
}: let
  isDarwin = pkgs.stdenv.isDarwin;
  isLinux = pkgs.stdenv.isLinux;

  bunGlobalPackages = [
    "@anthropic-ai/claude-code"
    "@ast-grep/cli"
    "@openai/codex"
    "@sourcegraph/amp"
    "@withgraphite/graphite-cli@stable"
    "jscpd"
  ];

  cliInstall = pkgs.writeShellScriptBin "cli-install" ''
    bun add -g ${lib.concatStringsSep " " bunGlobalPackages}
  '';

  shellAliases =
    {
      cd = "z";
      cat = "bat";
      find = "fd";
      grep = "rg";
      la = "ls -a";
      ll = "ls -l";

      ga = "git add";
      gc = "git commit";
      gco = "git checkout";
      gcu = "git cleanup";
      gcp = "git cherry-pick";
      gdiff = "git diff";
      gl = "git prettylog";
      gp = "git push";
      gs = "git status";

      jd = "jj desc";
      jf = "jj git fetch";
      jn = "jj new";
      jp = "jj git push";
      js = "jj st";
      je = "jj edit";

      v = "nvim";

      drs = "sudo darwin-rebuild switch --flake";
      hms = "home-manager switch --flake";
    }
    // lib.optionalAttrs isDarwin {
      tailscale = "/Applications/Tailscale.app/Contents/MacOS/Tailscale";
    };

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
in {
  home.stateVersion = "24.11";

  xdg.enable = true;

  home.packages =
    [
      pkgs.alejandra
      pkgs.ast-grep
      pkgs.bat
      pkgs.fd
      pkgs.fzf
      pkgs.gh
      pkgs.gopls
      pkgs.just
      pkgs.nodejs
      pkgs.ripgrep
      pkgs.stow
      pkgs.typst
      pkgs.uv
      pkgs.zigpkgs."0.15.1"
      cliInstall
      jgts
    ]
    ++ (lib.optionals isLinux [
      pkgs.cloudflared
      pkgs.postgresql_18
      pkgs.tailscale
    ]);

  home.sessionVariables = {
    EDITOR = "nvim";
    PAGER = "less -FirSwX";
    BUN_INSTALL = "$HOME/.bun";
  };

  home.sessionPath =
    [
      "$HOME/.bun/bin"
      "$HOME/.cargo/bin"
      "$HOME/.local/bin"
    ]
    ++ (lib.optionals isDarwin [
      "/opt/homebrew/bin"
    ]);

  programs.home-manager.enable = true;

  programs.fish = {
    enable = true;
    shellAliases = shellAliases;
    interactiveShellInit = ''
      # Nix
      set -Ux fish_greeting ""
      # End Nix
    '';
  };

  programs.direnv = {
    enable = true;
    config = {
      whitelist = {
        exact = ["${config.home.homeDirectory}/.envrc"];
      };
    };
  };

  programs.git = {
    enable = true;
    signing = {
      signByDefault = true;
      key = "~/.ssh/id_ed25519.pub";
    };
    settings = {
      alias = {
        prettylog = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative";
        cleanup = "!git for-each-ref --format '%(refname:short) %(upstream:short) %(upstream:track)' refs/heads | awk '$2 == \"\" || $3 ~ /\\[gone\\]/ {print $1}' | while read -r br; do git branch -D \"$br\"; done";
      };
      user.name = "Tom Ford";
      user.email = "t@tomrford.com";
      branch.autosetuprebase = "always";
      color.ui = true;
      github.user = "fordtom";
      push.default = "tracking";
      push.autoSetupRemote = true;
      init.defaultBranch = "main";
      gpg.format = "ssh";
      tag.gpgSign = true;
    };
  };

  programs.go = {
    enable = true;
    env = {
      GOPATH = "${config.home.homeDirectory}/code/go";
      GOPRIVATE = ["github.com/fordtom"];
    };
  };

  programs.jujutsu = {
    enable = true;
    settings = {
      user = {
        name = "Tom Ford";
        email = "t@tomrford.com";
      };
      signing = {
        behavior = "own";
        backend = "ssh";
        key = "~/.ssh/id_ed25519.pub";
      };
      aliases = {
        bump = ["bookmark" "move" "--from" "closest_bookmark(@)" "--to" "@"];
        drop = ["abandon" "--restore-descendants"];
        rt = ["rebase" "-d" "trunk()"];
      };
      revset-aliases = {
        "closest_bookmark(to)" = "heads(::to & bookmarks())";
      };
      ui = {
        default-command = "log";
      };
    };
  };

  programs.neovim = {
    enable = true;
  };

  programs.atuin = {
    enable = true;
  };

  programs.starship = {
    enable = true;
    settings = {
      character = {
        success_symbol = ">";
        error_symbol = ">";
      };

      nix_shell = {
        format = "via $symbol";
      };

      package = {
        disabled = true;
      };

      git_branch = {
        truncation_length = 20;
        truncation_symbol = "…";
      };
    };
  };

  programs.zoxide = {
    enable = true;
  };

  programs.bun = {
    enable = true;
    settings = {
      install = {
        exact = true;
        minimumReleaseAge = 259200;
        minimumReleaseAgeExcludes = [
          "@anthropic-ai/claude-code"
          "@openai/codex"
          "@sourcegraph/amp"
        ];
      };
    };
  };
}
