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
    pkgs.nodejs
    pkgs.ripgrep
    pkgs.stow
    pkgs.typst
    pkgs.uv

    pkgs.gopls
    pkgs.zigpkgs."0.15.1"

    pkgs.claude-code
    pkgs.codex
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  home.sessionPath = [
    "$HOME/.local/bin"
    "$HOME/.cargo/bin"
  ];

  # In the future, migrate dotfiles to use home-manager

  programs.bash = {
    enable = true;
    # shellOptions = [];
    historyControl = ["ignoredups" "ignorespace"];
    # initExtra = builtins.readFile ./bashrc; - THIS IS LOOKING FOR LOCAL DIR
    shellAliases = shellAliases;
  };

  programs.zsh = {
    enable = true;
    # initExtra = builtins.readFile ./zshrc;
    shellAliases = shellAliases;
  };

  programs.direnv = {
    enable = true;
    config = {
      whitelist = {
        exact = ["$HOME/.envrc"];
      };
    };
  };

  programs.git = {
    enable = true;
    userName = "Tom Ford";
    userEmail = "tfordy63@gmail.com";
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
}
