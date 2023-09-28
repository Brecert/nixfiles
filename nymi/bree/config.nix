{ config, lib, pkgs, packages, ... }:

lib.mkMerge [

  # XDG
  (
    let home = config.home.homeDirectory; in
    {
      xdg.enable = true;
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

      xdg.dataFile."sushi".source = "${packages.tower-unite-cache-thumbnailer}/share/sushi";
    }
  )

  # Fonts
  {
    fonts.fontconfig.enable = true;
  }

  # GTK
  {
    gtk.enable = true;
    gtk.theme.package = pkgs.gnome.gnome-themes-extra;
    gtk.theme.name = "Adwaita-dark";
  }
]
