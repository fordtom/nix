{inputs, ...}: {
  config,
  lib,
  pkgs,
  ...
}: let
  isDarwin = pkgs.stdenv.isDarwin;
  isLinux = pkgs.stdenv.isLinux;
  grepoPkg = inputs.grepo.packages.${pkgs.stdenv.hostPlatform.system}.default;

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
    }
    // lib.optionalAttrs isDarwin {
      tailscale = "/Applications/Tailscale.app/Contents/MacOS/Tailscale";
    };
in {
  home.stateVersion = "24.11";

  xdg.enable = true;

  xdg.configFile."pnpm/config.yaml".text = ''
    saveExact: true
    minimumReleaseAge: 4320
  '';

  home.file.".zshenv" = lib.mkIf isDarwin {
    source = ./ssh-agent.zsh;
  };

  home.packages =
    [
      grepoPkg
      pkgs._1password-cli
      pkgs.alejandra
      pkgs.bat
      pkgs.fd
      pkgs.fzf
      pkgs.gh
      pkgs.gopls
      pkgs.nodejs
      pkgs.neovim
      pkgs.pnpm
      pkgs.ripgrep
      pkgs.stow
    ]
    ++ (lib.optionals isLinux [
      pkgs.tailscale
    ]);

  home.sessionVariables = {
    EDITOR = "nvim";
    PAGER = "less -FirSwX";
    BUN_INSTALL = "$HOME/.bun";

    CARGO_REGISTRY_TOKEN = "op://Personal/CARGO_REGISTRY_TOKEN/credential";
    OPENAI_API_KEY = "op://Personal/OPENAI_API_KEY/credential";
    OPENROUTER_API_KEY = "op://Personal/OPENROUTER_API_KEY/credential";
  };

  home.sessionPath =
    [
      "$HOME/.bun/bin"
      "$HOME/.cargo/bin"
      "$HOME/.local/bin"
      "$HOME/.local/share/pnpm/bin"
    ]
    ++ (lib.optionals isDarwin [
      "/opt/homebrew/bin"
    ]);

  programs.home-manager.enable = true;

  programs.fish = {
    enable = true;
    shellAliases = shellAliases;
    shellInit = lib.optionalString isDarwin (builtins.readFile ./ssh-agent.fish);
    interactiveShellInit = ''
      # Nix
      set -Ux fish_greeting ""
      # End Nix
    '';
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
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
      key = "~/.ssh/id_ed25519_github_signing.pub";
    };
    settings = {
      alias = {
        prettylog = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative";
        cleanup = "!git for-each-ref --format '%(refname:short) %(upstream:short) %(upstream:track)' refs/heads | awk '$2 == \"\" || $3 ~ /\\[gone\\]/ {print $1}' | while read -r br; do git branch -D \"$br\"; done";
        update = "!git checkout main && git fetch --prune && git pull && git cleanup";
      };
      user.name = "Tom Ford";
      user.email = "t@tomrford.com";
      branch.autoSetupRebase = "always";
      color.ui = true;
      github.user = "tomrford";
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

  programs.nushell = {
    enable = true;
    shellAliases = shellAliases;
    plugins = with pkgs.nushellPlugins; [ polars formats gstat query ];
    settings = {
      show_banner = false;
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
      };
    };
  };

  programs.tmux = {
    enable = true;
  };

  programs.uv = {
    enable = true;
    settings = {
      exclude-newer = "3 days";
    };
  };

  programs.lazygit = {
    enable = true;
    settings = {
      promptToReturnFromSubprocess = false;
    };
  };
}
