{
  description = "Nix config inspired by mitchellh's nixos-config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";

    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    qmd = {
      url = "github:tobi/qmd";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    monitor = {
      url = "github:tomrford/monitor-cli";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    darwin,
    ...
  } @ inputs: let
    overlays = [
      (final: prev: {
        unstable = import inputs.nixpkgs-unstable {
          inherit (final.stdenv.hostPlatform) system;
          config.allowUnfree = true;
        };
        qmd = inputs.qmd.packages.${final.stdenv.hostPlatform.system}.default;
      })
    ];

    mkSystem = import ./lib/mksystem.nix {
      inherit inputs nixpkgs overlays;
    };

    mkHome = import ./lib/mkhome.nix {
      inherit inputs nixpkgs overlays;
    };
  in {
    darwinConfigurations.macbook = mkSystem "macbook" {
      system = "aarch64-darwin";
      user = "tomford";
      darwin = true;
    };

    darwinConfigurations.macmini = mkSystem "macmini" {
      system = "aarch64-darwin";
      user = "tomford";
      darwin = true;
    };

    homeConfigurations."pifive" = mkHome {
      system = "aarch64-linux";
      user = "tomford";
    };
  };
}
