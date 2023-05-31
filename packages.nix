{ lib
, callPackage
, callPackages
# required inputs
, system
, slippi
}:

let 
  self = {
    inherit slippi;

    odin = callPackage ./packages/odin { };
    ols = callPackage ./packages/ols { odin = self.odin; };
    ueviewer = callPackage ./packages/ueviewer { };
    hexpat-lsp = callPackage ./packages/hexpat-lsp { };
    
    gnome-circle = lib.recurseIntoAttrs (callPackages ./packages/gnome/circle.nix { });
  };
in
  self