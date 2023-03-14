{ config, options, lib, formats, pkgs, ... }:

let
  inherit (lib) mkOption mkIf types literalExpression;
  jsonFormat = pkgs.formats.json { };
  cfg = config.home-modules.vscode;
in
{
  options.home-modules.vscode = {
    outOfStoreUserSettings = mkOption {
      type = types.nullOr (types.str);
      default = null;
      description = ''
        Path to settings to link and use for Visual Studio Code's 
        <filename>settings.json</filename>.
      '';
    };

    overrideUserSettings = mkOption {
      type = jsonFormat.type;
      default = { };
      example = literalExpression ''
        {
          "files.autoSave" = "off";
          "[nix]"."editor.tabSize" = 2;
        }
      '';
      description = ''
        This is impure.
        Configuration to merge with Visual Studio Code's
        <filename>settings.json</filename>.
      '';
    };
  };

  config = mkIf config.programs.vscode.enable {
    # todo: skip if not needed
    home.activation.vscode-user-settings = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      $DRY_RUN_CMD ${pkgs.yq-go}/bin/yq --inplace --output-format=json \
        '. *= load("${jsonFormat.generate "vscode-user-settings-override.json" cfg.overrideUserSettings}")' \
        "${cfg.outOfStoreUserSettings}"

      $DRY_RUN_CMD ln -sf \
        "${cfg.outOfStoreUserSettings}" \
        "${config.xdg.configHome}/Code/User/settings.json"
    '';
  };
}