# sudo nixos-rebuild switch --flake .#
{
  description = "My NixOS config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    slippi.url = "path:flakes/slippi";

    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, slippi, fenix, home-manager, ... }@inputs:
    let
      inherit (self) outputs;
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      packages = outputs.packages.x86_64-linux;
      slippi-packages = slippi.packages.x86_64-linux;
      inherit (pkgs) callPackage callPackages;
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
          (_: { nixpkgs.overlays = [ fenix.overlays.default ]; })
          home-manager.nixosModules.home-manager
          ./nymi/configuration.nix
        ];
      };

      packages.x86_64-linux = {
        inherit (slippi-packages) slippi-netplay;

        odin = callPackage ./packages/odin { };
        ols = callPackage ./packages/ols { inherit (packages) odin; };
        ueviewer = callPackage ./packages/ueviewer { };
        gnome.circle = callPackages ./packages/gnome/circle.nix { };
        hexpat-lsp = callPackage ./packages/hexpat-lsp { };
      };

      formatter.x86_64-linux = pkgs.nixpkgs-fmt;
    };
}
