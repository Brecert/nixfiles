{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    nixpkgs-fmt

    polymc
    tdesktop
    sublime-merge

    gnome.gnome-boxes
    gnome.gnome-tweaks

    gnomeExtensions.appindicator
    gnomeExtensions.blur-my-shell
    gnomeExtensions.ddterm
    gnomeExtensions.desktop-cube
    gnomeExtensions.vitals
  ];
}
