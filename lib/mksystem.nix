# Defines the wiring for building a given system config.
{inputs}: name: {
  system,
  user,
}: let
  machineConfig = ../machines/${name}.nix;
  userOSConfig = ../users/${user}/darwin.nix;
  userHMConfig = ../users/${user}/home-manager.nix;
in
  inputs.darwin.lib.darwinSystem {
    inherit system;

    modules = [
      {nixpkgs.config.allowUnfree = true;}

      machineConfig
      userOSConfig
      inputs.home-manager.darwinModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users.${user} = import userHMConfig {
          inputs = inputs;
        };
      }

      {
        config._module.args = {
          currentSystem = system;
          currentSystemName = name;
          currentSystemUser = user;
          inputs = inputs;
        };
      }
    ];
  }
