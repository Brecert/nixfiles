# sudo nixos-rebuild switch --flake .#
{
  description = "My NixOS config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      inherit (self) outputs;
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      packages = outputs.packages.x86_64-linux;
      inherit (pkgs) callPackage;
    in
    {
      nixosConfigurations.nymi = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        
        specialArgs = {
          inherit inputs outputs packages; 
        };

        modules = [
          home-manager.nixosModules.home-manager
          ./nymi/configuration.nix
        ];
      };

      packages.x86_64-linux = {
        odin = callPackage ./packages/odin { };
        ols = callPackage ./packages/ols { inherit (pkgs); inherit (packages) odin; };
      };

      formatter.x86_64-linux = pkgs.nixpkgs-fmt;
    };
}
