{
  description = "Nix config inspired by mitchellh's nixos-config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";

    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    nixos-wsl.url = "github:nix-community/NixOS-WSL";
    nixos-wsl.inputs.nixpkgs.follows = "nixpkgs";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    jujutsu.url = "github:jj-vcs/jj";
    zig.url = "github:mitchellh/zig-overlay";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    darwin,
    ...
  } @ inputs: let
    overlays = [
      inputs.jujutsu.overlays.default
      inputs.zig.overlays.default

      (final: prev: {
        unstable = import inputs.nixpkgs-unstable {
          inherit (final.stdenv.hostPlatform) system;
          config.allowUnfree = true;
        };
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

    # Home Manager standalone for WSL Ubuntu
    homeConfigurations."ubuntuwsl" = mkHome {
      system = "x86_64-linux";
      user = "tfo01";
      isWSL = true;
    };
  };
}
