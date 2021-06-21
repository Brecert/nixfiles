{ config, lib, pkgs, ... }:

with lib;

{
  config = {
    bree = mkOption {
      type = types.attrsOf (types.submodule ({config, name, ...}: {
        options = {
          name = mkOption {
            type = types.str;
            default = name;
            description = "Profile name.";
          };
        };
      }));
      description = "The version";
      default = { };
    };
  };
}