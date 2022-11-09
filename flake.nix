# sudo nixos-rebuild switch --flake .#
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }: {
    nixosConfigurations.nymi = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        # compatability with old nix
        { nix.nixPath = [ "nixpkgs=${nixpkgs}" ]; }
        home-manager.nixosModules.home-manager
        ./nymi/configuration.nix
      ];
    };
  };
}
