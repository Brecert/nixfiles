{ config, lib, pkgs, packages, ... }:

let
  imhex-up = pkgs.imhex.overrideAttrs (final: prev: rec {
    version = "1.29.0";

    src = pkgs.fetchFromGitHub {
      fetchSubmodules = true;
      owner = "WerWolv";
      repo = prev.pname;
      rev = "v${version}";
      hash = "sha256-dghyv7rpqGs5dt51ziAaeb/Ba7rGEcJ54AYKRJ2xXuk=";
    };

    cmakeFlags = prev.cmakeFlags ++ [
      "DCREATE_PACKAGE=ON"
    ];
  });
in

{
  home.packages = with pkgs; [
    cachix
    nixpkgs-fmt
    rnix-lsp

    tdesktop
    prismlauncher
    sublime-merge

    imhex-up
    packages.hexpat-lsp

    packages.slippi-netplay

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

    # swift
    # sourcekit-lsp
    # swift
    # swiftPackages.swiftpm
    # swiftPackages.Dispatch
    # swiftPackages.Foundation
    # swiftPackages.XCTest
  ];
}
