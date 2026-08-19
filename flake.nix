{
  description = "Nix config inspired by mitchellh's nixos-config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";

    darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs: let
    mkSystem = import ./lib/mksystem.nix {inherit inputs;};
  in {
    darwinConfigurations.macbook = mkSystem "macbook" {
      system = "aarch64-darwin";
      user = "tomford";
    };

    darwinConfigurations.macmini = mkSystem "macmini" {
      system = "aarch64-darwin";
      user = "tomford";
    };
  };
}
