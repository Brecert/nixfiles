{ config, pkgs, ... }: {

  imports = [
    ./config.nix
    ./packages.nix
    ./programs.nix
  ];

  home = {
    username = "bree";
    homeDirectory = "/home/bree";
  };

  home.stateVersion = "21.11";
}
