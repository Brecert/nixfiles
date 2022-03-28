{ config, lib, pkgs, ... }:
{
  home.packages = with pkgs; [
    nixpkgs-fmt
    
    polymc
    tdesktop
    sublime-merge

    gnomeExtensions.appindicator
  ];
}
