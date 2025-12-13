{
  inputs,
  nixpkgs,
  overlays,
}: {
  system,
  user,
}: let
  pkgs = import nixpkgs {
    inherit system overlays;
    config.allowUnfree = true;
  };
  userHMConfig = ../users/${user}/home-manager.nix;
in
  inputs.home-manager.lib.homeManagerConfiguration {
    inherit pkgs;

    extraSpecialArgs = {
      inputs = inputs;
    };

    modules = [
      (import userHMConfig {
        inputs = inputs;
      })
      {
        home.username = user;
        home.homeDirectory = "/home/${user}";
      }
    ];
  }
