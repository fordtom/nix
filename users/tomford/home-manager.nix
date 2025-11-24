{
  isWSL,
  inputs,
  ...
}: {
  config,
  lib,
  pkgs,
  ...
}: let
  isDarwin = pkgs.stdenv.isDarwin;
  isLinux = pkgs.stdenv.isLinux;

  shellAliases = {
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
    gt = "git tag";

    jd = "jj desc";
    jf = "jj git fetch";
    jn = "jj new";
    jp = "jj git push";
    js = "jj st";
    je = "jj edit";

    v = "nvim";

    drs = "sudo darwin-rebuild switch --flake";
    hms = "home-manager switch --flake";
  };
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
      pkgs.just
      pkgs.nodejs
      pkgs.ripgrep
      pkgs.stow
      pkgs.typst
      pkgs.uv
      pkgs.gopls
      pkgs.zigpkgs."0.15.1"
    ]
    ++ (lib.optionals isLinux [
      pkgs.postgresql
    ]);

  home.sessionVariables = {
    EDITOR = "nvim";
    PAGER = "less -FirSwX";
  };

  home.sessionPath = [
    "$HOME/.local/bin"
    "$HOME/.cargo/bin"
  ];

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
    userName = "Tom Ford";
    userEmail = "t@tomrford.com";
    signing = {
      signByDefault = true;
      key = "~/.ssh/id_ed25519.pub";
    };
    aliases = {
      prettylog = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative";
      cleanup = "!git for-each-ref --format '%(refname:short) %(upstream:short) %(upstream:track)' refs/heads | awk '$2 == \"\" || $3 ~ /\\[gone\\]/ {print $1}' | while read -r br; do git branch -D \"$br\"; done";
    };
    extraConfig = {
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
    goPath = "code/go";
    goPrivate = ["github.com/fordtom"];
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
    package = pkgs.unstable.bun;
    settings = {
      install = {
        exact = true;
        minimumReleaseAge = 259200;
      };
    };
  };
}
