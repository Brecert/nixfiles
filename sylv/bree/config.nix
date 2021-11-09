{ config, lib, ... }:
lib.mkMerge [

  # XDG
  (
    let home = config.home.homeDirectory; in
    {
      xdg.userDirs = {
        enable = true;
        desktop = "${home}/Desktop";
        documents = "${home}/Documents";
        download = "${home}/Downloads";
        music = "${home}/Music";
        pictures = "${home}/Pictures";
        publicShare = "${home}/Public";
        templates = "${home}/Templates";
        videos = "${home}/Videos";
        extraConfig = {
          XDG_CONFIG_HOME = "${home}/.config";
          XDG_CACHE_HOME = "${home}/.cache";
        };
      };
    }
  )

  # Fonts
  {
    fonts.fontconfig.enable = true;
  }
]
