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

    drs = "sudo darwin-rebuild switch --flake ~/nix#macbook";
  };
in {
  home.stateVersion = "24.11";

  xdg.enable = true;

  home.packages = [
    pkgs.alejandra
    pkgs.bat
    pkgs.fd
    pkgs.fzf
    pkgs.gh
    pkgs.ripgrep
    pkgs.stow
    pkgs.typst
    pkgs.uv
    pkgs.gopls

    pkgs.unstable.claude-code
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  home.sessionPath = [
    "$HOME/.local/bin"
    "$HOME/.cargo/bin"
  ];

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
    userEmail = "tfordy63@gmail.com";
    signing = {
      signByDefault = true;
      key = "~/.ssh/id_ed25519.pub";
    };
    aliases = {
      prettylog = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative";
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
    };
  };

  programs.zoxide = {
    enable = true;
  };
}
