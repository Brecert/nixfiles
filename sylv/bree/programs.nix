{ conifg, lib, pkgs, ... }:
lib.mkMerge [

  # Git
  {
    programs.git = {
      enable = true;

      userEmail = "me@bree.dev";
      userName = "brecert";

      signing = {
        signByDefault = true;
        key = "1B2E56B9EC985B96";
      };

      includes = [{
        contents.user.name = "bree";
        condition = "gitdir:~/Code/projects/revolt/";
      }];

      extraConfig = {
        init.defaultBranch = "main";
        credential.helper = "store"; # todo: fix this

        url = {
          # nix consistency, not really gonna use this
          "https://github.com/" = { insteadOf = "github:"; };
        };
      };
    };
  }

  # Firefox
  (
    let
      firefox-gnome-theme = pkgs.fetchFromGitHub {
        owner = "brecert";
        repo = "firefox-gnome-theme";
        rev = "0b4065ff35e5034cd096fef8f3a5981dd751a48e";
        hash = "sha256-kyfzjwVp73xIofJ+1CxLocqSb9Or5nZjH123yNBFHoY=";
      };
    in
    {
      programs.firefox = {
        enable = true;
        profiles.primary = {
          isDefault = true;

          settings = {
            "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
          };

          userChrome = ''
            @import "${firefox-gnome-theme}/userChrome.css"
          '';
        };
      };
    }
  )

  # Fish
  {
    programs.fish = {
      enable = true;

      # use fish shell when running `nix develop`
      interactiveShellInit = ''
        ${pkgs.any-nix-shell}/bin/any-nix-shell fish --info-right | source
      '';

      shellAliases = with pkgs; {
        l = "${pkgs.exa}/bin/exa -l";
        ls = "${pkgs.exa}/bin/exa";
        pd = "prevd";
      };
    };
  }

  # Starship
  {
    programs.starship = {
      enable = true;
      enableFishIntegration = true;
    };
  }

  # Alacritty
  {
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
  }

  # Emacs
  # todo: put the witchmacs config here
  {
    programs.emacs.enable = true;
    services.emacs.enable = true;
  }
]
