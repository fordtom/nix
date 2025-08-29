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
    ls = "eza";
    la = "eza --all";
    ll = "eza --long --header --all --group-directories-first";

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
    };

    includes = [
      {
        path = "/mnt/c/Users/${windowsUser}/.gitconfig";
      }
    ];

    extraConfig = {
      credential.helper = "/mnt/c/Program Files/Git/mingw64/bin/git-credential-manager.exe";
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
      add_newline = false;
      format = "$directory$character";
      right_format = "$all";

      character = {
        success_symbol = ">";
        error_symbol = ">";
      };

      git_branch = {
        format = "[$symbol$branch(:$remote_branch) ]($style)";
      };

      nix_shell = {
        format = "via $symbol";
      };
    };
  };

  programs.zoxide = {
    enable = true;
  };

  programs.eza = {
    enable = true;
    icons = "always";
  };
}
