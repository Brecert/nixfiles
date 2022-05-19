{ config, lib, pkgs, ... }:
{
  home.packages = with pkgs; [
    nixpkgs-fmt
    gnome.gnome-boxes

    polymc
    tdesktop
    sublime-merge

    gnomeExtensions.appindicator
  ];
}
