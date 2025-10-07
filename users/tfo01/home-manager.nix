{
  config,
  lib,
  pkgs,
  isWSL ? false,
  inputs,
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

    hms = "home-manager switch --flake ~/nix#ubuntuwsl";
    vscode = "bash -c \"code .\"";
  };

  windowsUser = config.home.username;
in {
  home.stateVersion = "24.11";

  xdg.enable = true;

  home.packages = [
    pkgs.alejandra
    pkgs.bat
    pkgs.fd
    pkgs.fzf
    pkgs.ripgrep
    pkgs.stow
    pkgs.fish
    pkgs.uv
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  home.sessionPath = [
    "$HOME/.local/bin"
    "$HOME/.cargo/bin"
  ];

  programs.home-manager.enable = true;

  programs.bash = {
    enable = true;
    shellAliases = shellAliases;
  };

  programs.fish = {
    enable = true;
    shellAliases = shellAliases;
    interactiveShellInit = ''
      # Nix
      set -Ux fish_greeting ""
      if test -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish'
        source '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish'
      end
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
    aliases = {
      prettylog = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative";
      cleanup = "!git for-each-ref --format '%(refname:short) %(upstream)' refs/heads | awk '$2 == \"\" {print $1}' | xargs -r git branch -D";
    };

    includes = [
      {
        path = "/mnt/c/Users/${windowsUser}/.gitconfig";
      }
    ];

    extraConfig = {
      credential.helper = "/mnt/c/Program\\ Files/Git/mingw64/bin/git-credential-manager.exe";
    };
  };

  programs.neovim = {
    enable = true;
  };

  programs.atuin = {
    enable = true;
  };

  programs.zoxide = {
    enable = true;
  };
}
