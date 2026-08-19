# Defines the wiring for building a given system config.
{inputs}: name: {
  system,
  user,
}:
inputs.darwin.lib.darwinSystem {
  inherit system;

  modules = [
    ../machines/${name}.nix
    ({pkgs, ...}: {
      users.users.${user} = {
        home = "/Users/${user}";
        shell = pkgs.fish;
      };
    })
  ];
}
