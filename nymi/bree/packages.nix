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
  home.packages =
    [ imhex-up ]
    ++ (with pkgs; [
      # Applications
      tdesktop
      prismlauncher
      sublime-merge

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
