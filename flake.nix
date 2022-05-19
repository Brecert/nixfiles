{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nixos-hardware = {
      url = "github:NixOS/nixos-hardware/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixos-hardware, home-manager, ... }: {
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
