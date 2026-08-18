# Defines the wiring for building a given system config.
{inputs}: name: {
  system,
  user,
}: let
  machineConfig = ../machines/${name}.nix;
  userHMConfig = ../users/${user}/home-manager.nix;
in
  inputs.darwin.lib.darwinSystem {
    inherit system;

    modules = [
      {nixpkgs.config.allowUnfree = true;}

      machineConfig
      inputs.home-manager.darwinModules.home-manager
      ({pkgs, ...}: {
        users.users.${user} = {
          home = "/Users/${user}";
          shell = pkgs.fish;
        };

        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users.${user} = import userHMConfig {
          inputs = inputs;
        };
      })
    ];
  }
