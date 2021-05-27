{
  inputs = {
    # Currently broken so...
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware = {
      url = github:NixOS/nixos-hardware/master;
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixos-hardware, home-manager, ... }: {
    # Configuration for the sylv host
    nixosConfigurations.sylv = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        nixos-hardware.nixosModules.dell-xps-15-7590
        nixos-hardware.nixosModules.common-gpu-nvidia
        home-manager.nixosModules.home-manager
        ./sylv/configuration.nix
      ];
    };
  };
}
