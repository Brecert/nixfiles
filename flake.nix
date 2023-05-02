# sudo nixos-rebuild switch --flake .#
{
  description = "My NixOS config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # prismlauncher building broke for the latest updates, so we use the previous working nixpkgs rev
    nixpkgs-prismlauncher.url = "github:nixos/nixpkgs?rev=1e2590679d0ed2cee2736e8b80373178d085d263";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-prismlauncher, home-manager, ... }@inputs:
    let
      inherit (self) outputs;
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      pkgs-prismlauncher = nixpkgs-prismlauncher.legacyPackages.x86_64-linux;
      packages = outputs.packages.x86_64-linux;
      inherit (pkgs) callPackage;
    in
    {
      nixosConfigurations.nymi = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        
        specialArgs = {
          inherit inputs outputs packages; 
          # todo: impure derivation or some automatic alternative to this
          flakePath = "/home/bree/Documents/nixfiles";
        };

        modules = [
          home-manager.nixosModules.home-manager
          ./nymi/configuration.nix
        ];
      };

      packages.x86_64-linux = {
        odin = callPackage ./packages/odin { };
        ols = callPackage ./packages/ols { inherit (pkgs); inherit (packages) odin; };
        prismlauncher = pkgs-prismlauncher.prismlauncher;
      };

      formatter.x86_64-linux = pkgs.nixpkgs-fmt;
    };
}
