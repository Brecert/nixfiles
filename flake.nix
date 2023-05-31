# sudo nixos-rebuild switch --flake .#
{
  description = "My NixOS config";
  
  nixConfig = {
      substituters = [
        "https://cache.nixos.org/"
        "https://devenv.cachix.org"
        "https://nix-community.cachix.org"
      ];
      
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";

    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    slippi.url = "path:flakes/slippi";
  };

  outputs = { self, nixpkgs, fenix, home-manager, slippi, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      slippi-pkgs = slippi.packages.${system};
    in
    {
      nixosConfigurations.nymi = nixpkgs.lib.nixosSystem {
        inherit system;

        specialArgs = {
          inherit (self) outputs;
          inherit inputs;
          # todo: impure derivation or some automatic alternative to this
          # used for vscode module
          flakePath = "/home/bree/Documents/nixfiles";
          
          packages = self.packages.${system};
        };

        modules = [
          { nixpkgs.overlays = [ fenix.overlays.default ]; }
          home-manager.nixosModules.home-manager
          ./nymi/configuration.nix
        ];
      };

      packages.${system} = pkgs.callPackages ./packages.nix { inherit system; slippi = slippi-pkgs; };
      formatter.${system} = pkgs.nixpkgs-fmt;
    };
}
