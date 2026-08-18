{inputs, ...}: {
  config,
  pkgs,
  ...
}: let
  grepoPkg = inputs.grepo.packages.${pkgs.stdenv.hostPlatform.system}.default;

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

    v = "nvim";
    drs = "sudo darwin-rebuild switch --flake";
    tailscale = "/Applications/Tailscale.app/Contents/MacOS/Tailscale";
  };
in {
  home.stateVersion = "24.11";

  xdg.enable = true;

  home.file.".zshenv" = {
    source = ./ssh-agent.zsh;
  };

  home.packages = [
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
    pkgs.tmux
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    PAGER = "less -FirSwX";
    BUN_INSTALL = "$HOME/.bun";

    OPENAI_API_KEY = "op://Personal/OPENAI_API_KEY/credential";
    OPENROUTER_API_KEY = "op://Personal/OPENROUTER_API_KEY/credential";
  };

  home.sessionPath = [
    "$HOME/.bun/bin"
    "$HOME/.cargo/bin"
    "$HOME/.local/bin"
    "$HOME/.local/share/pnpm/bin"
    "/opt/homebrew/bin"
  ];

  programs.home-manager.enable = true;

  programs.fish = {
    enable = true;
    shellAliases = shellAliases;
    shellInit = builtins.readFile ./ssh-agent.fish;
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

  programs.starship.enable = true;

  programs.zoxide = {
    enable = true;
  };

  programs.bun.enable = true;

  programs.uv.enable = true;

  programs.lazygit.enable = true;
}
