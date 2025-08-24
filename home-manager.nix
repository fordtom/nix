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
    pkgs.zigpkgs."0.14.1"

    pkgs.claude-code
    pkgs.codex
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  # In the future, migrate dotfiles to use home-manager

  programs.bash = {
    enable = true;
    shellOptions = [];
    historyControl = ["ignoredups" "ignorespace"];
    # initExtra = builtins.readFile ./bashrc; - THIS IS LOOKING FOR LOCAL DIR
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

  # programs.git to replace .gitconfig

  programs.go = {
    enable = true;
    goPath = "code/go";
    goPrivate = ["github.com/tomford"];
  };

  programs.jujutsu = {
    enable = true;
  };

  programs.neovim = {
    enable = true;
  };
}
