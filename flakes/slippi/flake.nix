{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs";
  inputs.nixpkgs-old.url = "github:NixOS/nixpkgs/21.05";
  # inputs.slippi-desktop.url = "github:project-slippi/slippi-desktop-app";
  # inputs.slippi-desktop.flake = false;

  outputs = { self, nixpkgs, nixpkgs-old }: 
  let 
    system = "x86_64-linux"; 
    pkgs = nixpkgs.legacyPackages.${system};
    pkgs-old = nixpkgs-old.legacyPackages.${system};
  in {
    packages.${system}.slippi-netplay = pkgs-old.callPackage ./slippi-netplay { inherit (pkgs) makeDesktopItem; };
  };
}
