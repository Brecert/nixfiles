{ config, lib, pkgs, ... }:
{
  home.packages = with pkgs; [
    nixpkgs-fmt
    
    tdesktop
    sublime-merge

    gnomeExtensions.appindicator
  ];
}
