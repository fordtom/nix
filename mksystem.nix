# Defines the wiring for building a given system config.
{
  inputs,
  nixpkgs,
  overlays,
}: name: {
  system,
  user,
  darwin ? false,
  wsl ? false,
}: let
  isWSL = wsl;
  isLinux = !darwin && !isWSL;

  machineConfig = ./machines/${name}.nix;
  userOSConfig =
    ./users/${user}/${
      if darwin
      then "darwin"
      else "nixos"
    }.nix;
  userHMConfig = ./users/${user}/home-manager.nix;

  systemFunc =
    if darwin
    then inputs.darwin.lib.darwinSystem
    else nixpkgs.lib.nixosSystem;

  home-manager =
    if darwin
    then inputs.home-manager.darwinModules
    else inputs.home-manager.nixosModules;
in
  systemFunc rec {
    inherit system;

    modules = [
      {nixpkgs.overlays = overlays;}

      {nixpkgs.config.allowUnfree = true;}

      (
        if isWSL
        then inputs.nixos-wsl.nixosModules.wsl
        else {}
      )

      machineConfig
      userOSConfig
      home-manager.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users.${user} = import userHMConfig {
          isWSL = isWSL;
          inputs = inputs;
        };
      }

      {
        config._module.args = {
          currentSystem = system;
          currentSystemName = name;
          currentSystemUser = user;
          isWSL = isWSL;
          inputs = inputs;
        };
      }
    ];
  }
