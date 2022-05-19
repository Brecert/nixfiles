{ conifg, lib, pkgs, ... }:
lib.mkMerge [
  # GNOME Keyring
  {
    services.gnome-keyring.enable = true;
  }

  # Git
  {
    programs.git = {
      enable = true;
      package = pkgs.gitFull;

      userEmail = "me@bree.dev";
      userName = "brecert";

      signing = {
        signByDefault = true;
        key = "3D2C64AC1898ED49";
        # todo: key
      };

      extraConfig = {
        init.defaultBranch = "main";
        credential.helper = "libsecret";

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
        owner = "rafaelmardojai";
        repo = "firefox-gnome-theme";
        rev = "183b5f0b3d056646faf720abd720ba76da28a736";
        hash = "sha256-xAdzxjdLuGxgtM/eKTkccpLkAebLun5wD2dlrfgT8Us=";
      };
    in
    {
      programs.firefox = {
        enable = true;
        profiles.primary = {
          isDefault = true;

          settings = {
            "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
            "svg.context-properties.content.enabled" = true;
            "gnomeTheme.hideSingleTab" = true;
            "gnomeTheme.normalWidthTabs" = false;
          };

          userChrome = ''
            @import "${firefox-gnome-theme}/userChrome.css"
          '';
        };
      };
    }
  )

  # Chromium
  {
    programs.chromium = {
      enable = true;
      package = pkgs.ungoogled-chromium;
      extensions = [
        { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } # ublock origin
        { id = "lcmbpoclaodbgkbjafnkbbinogcbnjih"; } # lesspass
        { id = "clngdbkpkpeebahjckkjfobafhncgmne"; } # stylus
      ];
    };
  }

  # nix-index
  {
    programs.nix-index = {
      enable = true;
      enableFishIntegration = true;
      enableBashIntegration = true;
    };
  }

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

  # VSCode
  {
    programs.vscode = {
      enable = true;
    };
  }
]
