{ config, lib, pkgs, packages, ... }:

{
  home.packages = with pkgs; [
    cachix
    nixpkgs-fmt

    tdesktop
    prismlauncher
    sublime-merge

    gnome.gnome-boxes
    gnome.gnome-tweaks

    gnomeExtensions.appindicator
    gnomeExtensions.blur-my-shell
    gnomeExtensions.ddterm
    gnomeExtensions.desktop-cube
    gnomeExtensions.pano
    gnomeExtensions.vitals
    
    # odin
    packages.ols
    packages.odin

    # swift core libraries
    # swift
    # swiftPackages.swiftpm
    # swiftPackages.Dispatch
    # swiftPackages.Foundation
    # swiftPackages.XCTest
  ];
}
