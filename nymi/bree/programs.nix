{ config, lib, pkgs, packages, flakePath, ... }:

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
        rev = "v126";
        hash = "sha256-jVbj2JD5GRkP8s3vKBtd9PDpftf3kjLR0ZA/ND/c2+Q=";
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

      shellAliases = {
        l = "${pkgs.eza}/bin/eza -l";
        ls = "${pkgs.eza}/bin/eza";
        pd = "prevd";
        files = "nautilus";
      };
    };
  }

  # Direnv
  # {
  #   programs.direnv = {
  #     enable = true;
  #     nix-direnv.enable = true;
  #   };
  # }

  # VSCode
  {
    programs.vscode = {
      enable = true;

      mutableExtensionsDir = false;
      extensions = with pkgs.vscode-extensions; [
        rust-lang.rust-analyzer-nightly
        denoland.vscode-deno
        editorconfig.editorconfig
        tamasfe.even-better-toml
        github.github-vscode-theme
        piousdeer.adwaita-theme
        jnoortheen.nix-ide
        esbenp.prettier-vscode
        sumneko.lua
        ms-python.python
        ms-pyright.pyright
      ];
    };

    home-modules.vscode = {
      outOfStoreUserSettings = "${flakePath}/nymi/bree/vscode/settings.json";
      overrideUserSettings = {
        "ols.server.path" = "${packages.ols}/bin/ols";
        "nix.serverPath" = "${pkgs.nil}/bin/nil";
      };
    };

    # VSCodium instead of Code if VSCodium
    # home.file."${config.xdg.configHome}/Code/User/settings.json" = {
    #   source = config.lib.file.mkOutOfStoreSymlink ./vscode/settings.json;
    # };
  }

  # OBS
  # {
  #   programs.obs-studio = {
  #     enable = true;
  #     plugins = with pkgs.obs-studio-plugins; [
  #       wlrobs
  #       obs-nvfbc
  #       obs-vkcapture
  #       obs-pipewire-audio-capture
  #     ];
  #   };
  # }
]
