{ config, lib, pkgs, packages, ... }:

{
  home.packages =
    (with pkgs; [
      # Applications
      tdesktop
      prismlauncher
      sublime-merge
      imhex
      livecaptions
      kooha
      eyedropper

      # bnnuychat development (temporary)
      clang
      rustup
      nodejs-18_x
      nodePackages_latest.pnpm
      deno

      # aoc (temporary)
      ruby
      
      (python3.withPackages(ps: [
        ps.numpy
        ps.scipy
        ps.requests
        ps.setuptools
      ]))
      python3Packages.pyside6

      qt6.full
      qtcreator
      
      qgnomeplatform-qt6
      adwaita-qt6

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
      rpcs3

      # Utils / Tools
      ols
      odin
      hexpat-lsp
      tower-unite-cache-thumbnailer
    ]);
}
