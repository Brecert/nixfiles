{ lib
, callPackage
, callPackages
# required inputs
, system
, slippi
, tower-unite-cache
, ataraxiadev-nur
}:

let 
  self = {
    inherit slippi;
    inherit (tower-unite-cache) tower-unite-cache tower-unite-cache-thumbnailer;

    odin = callPackage ./packages/odin { };
    ols = callPackage ./packages/ols { odin = self.odin; };
    ueviewer = callPackage ./packages/ueviewer { };
    hexpat-lsp = callPackage ./packages/hexpat-lsp { };
    fuchsia-cursor = callPackage ./packages/fuchsia-cursor { };
    
    rpcs3 = ataraxiadev-nur.rpcs3;
    rusty-psn = callPackage ./packages/rusty-psn { withGui = false; };
    rusty-psn-gui = callPackage ./packages/rusty-psn { withGui = true; };
    
    gnome-circle = lib.recurseIntoAttrs (callPackages ./packages/gnome/circle.nix { });
  };
in
  self