{ config, pkgs, ... }:
let
  firefox-gnome-theme = pkgs.fetchFromGitHub {
    owner = "brecert";
    repo="firefox-gnome-theme";
    rev="0b4065ff35e5034cd096fef8f3a5981dd751a48e";
    hash="sha256-kyfzjwVp73xIofJ+1CxLocqSb9Or5nZjH123yNBFHoY=";
  };
in {
  # configure the git version control system
  programs.git = {
    enable = true;
    userEmail = "me@bree.dev";
    userName = "brecert";
    signing = {
      key = "1B2E56B9EC985B96";
      signByDefault = true;
    };
    extraConfig = {
      init.defaultBranch = "main";
      credential.helper = "store";
    };
    includes = [
      {
        contents = {
          user.name = "bree";
        };
        condition = "gitdir:~/Code/projects/revolt/";
      }
    ];
  };

  # configure the firefox web browser
  programs.firefox = {
    enable = true;
    profiles.primary = {
      isDefault = true;
      extraConfig=builtins.readFile(firefox-gnome-theme + "/configuration/user.js");
      userChrome=''
        @import "${firefox-gnome-theme}/userChrome.css"
      '';
    };
  };

  # home.file.".mozilla/firefox/${config.programs.firefox.profiles.primary.path}/firefox-gnome-theme" = {
  #   source = firefox-gnome-theme;
  # };

  # enable the direnv environment loader
  programs.direnv = {
    enable = true;
    enableFishIntegration = true;
    nix-direnv.enable = true;
  };

  # configure the fish shell
  programs.fish = {
    enable = true;
    shellAliases = with pkgs; {
      l = "${exa}/bin/exa -l";
      ls = "${exa}/bin/exa";
      pd = "prevd";
    };
  };

  # configure starship prompt
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
  };

  # configure the alacritty terminal emulator
  programs.alacritty = {
    enable = true;
    settings = {
      font.size = 10;
      window = {
        padding = {
          x = 5;
          y = 5;
        };
      };
    };
  };

  # enable mpd
  # services.mpd = {
  #   enable = true;
  #   musicDirectory = config.home.programs.beets.settings.directory;
  # };

  # # enable beets
  # programs.beets = {
  #   enable = true;
  #   settings = {
  #     directory = config.xdg.userDirs.music;
  #     library = "${config.xdg.userDirs.music}/library.db";
  #   };
  # };

  # enable services
  programs.emacs.enable = true;
  services.emacs.enable = true;

  # enable the syncthing file synchronization tool
  services.syncthing.enable = true;
}