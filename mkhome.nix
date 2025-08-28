{
  inputs,
  nixpkgs,
  overlays,
}: {
  system,
  user,
  isWSL ? false,
}: let
  pkgs = import nixpkgs {
    inherit system overlays;
    config.allowUnfree = true;
  };
  userHMConfig = ./users/${user}/home-manager.nix;
in
  inputs.home-manager.lib.homeManagerConfiguration {
    inherit pkgs;

    extraSpecialArgs = {
      isWSL = isWSL;
      inputs = inputs;
    };

    modules = [
      userHMConfig
      {
        home.username = user;
        home.homeDirectory = "/home/${user}";
      }
    ];
  }
