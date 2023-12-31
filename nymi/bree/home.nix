{ config, pkgs, packages, ... }:
{
  imports = [
    ./config.nix
    ./packages.nix
    ./programs.nix
    ../../modules/home/vscode.nix
  ];

  home = {
    username = "bree";
    homeDirectory = "/home/bree";

    # pointerCursor = {
    #   package = packages.fuchsia-cursor;
    #   name = "Fuchsia";
    #   size = 32;
    #   gtk.enable = true;
    #   x11.enable = true;
    # };
  };

  home.stateVersion = "21.11";
}
