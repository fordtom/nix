{inputs, ...}: {
  config,
  lib,
  pkgs,
  ...
}: let
  isDarwin = pkgs.stdenv.isDarwin;
  isLinux = pkgs.stdenv.isLinux;
  scripts = import ./scripts.nix {inherit pkgs lib;};

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

      v = "nvim";

      drs = "sudo darwin-rebuild switch --flake";
      hms = "home-manager switch --flake";

      claude = "command claude --allow-dangerously-skip-permissions";
      codex = "command codex --yolo";
      a = "agent -f";
    }
    // lib.optionalAttrs isDarwin {
      tailscale = "/Applications/Tailscale.app/Contents/MacOS/Tailscale";
    };
in {
  home.stateVersion = "24.11";

  xdg.enable = true;

  home.packages =
    [
      pkgs._1password-cli
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
      pkgs.signal-cli
      pkgs.stow
      pkgs.tig
      pkgs.uv

      scripts.bunInstall
      scripts.cliInstall
    ]
    ++ (lib.optionals isLinux [
      pkgs.tailscale
    ]);

  home.sessionVariables = {
    EDITOR = "nvim";
    PAGER = "less -FirSwX";
    BUN_INSTALL = "$HOME/.bun";

    AMP_API_KEY = "op://Personal/AMP_API_KEY/credential";
    CARGO_REGISTRY_TOKEN = "op://Personal/CARGO_REGISTRY_TOKEN/credential";
  };

  home.sessionPath =
    [
      "$HOME/.amp/bin"
      "$HOME/.bun/bin"
      "$HOME/.cargo/bin"
      "$HOME/.local/bin"
      "$HOME/.opencode/bin"
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
    lfs.enable = true;
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
      github.user = "tomrford";
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
      GOPRIVATE = ["github.com/tomrford"];
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
          "@openai/codex"
        ];
      };
    };
  };

  programs.tmux = {
    enable = true;
    mouse = true;
  };
}
