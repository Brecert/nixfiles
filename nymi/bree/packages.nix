{ config, lib, pkgs, packages, ... }:

{
  home.packages =
    (with pkgs; [
      # Applications
      tdesktop
      prismlauncher
      sublime-merge
      imhex

      # Nix Utils
      nil
      cachix
      nixpkgs-fmt

      # Gnome
      gnome.gnome-boxes
      gnome.gnome-tweaks

      gnomeExtensions.appindicator
      gnomeExtensions.blur-my-shell
      gnomeExtensions.ddterm
      gnomeExtensions.desktop-cube
      gnomeExtensions.pano
      gnomeExtensions.vitals      
    ])
    ++ (with packages; [
      # Applications
      slippi.slippi-online

      # Utils / Tools
      ols
      odin
      hexpat-lsp
    ]);
}
