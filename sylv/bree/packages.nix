{ pkgs, ... }: 
let
  extensions = with pkgs.vscode-extensions; [
    # akamud.vscode-theme-onelight
    # vincentfiestada.cold-horizon-vscode
    # crystal-lang-tools.crystal-lang
    # denoland.vscode-deno
    dracula-theme.theme-dracula
    github.github-vscode-theme
    # rreverser.llvm
    # vitoravelino.mosaic
    bbenoist.Nix
    jnoortheen.nix-ide
    # arcticicestudio.nord-visual-studio-code
    # tinkertrain.theme-panda
    esbenp.prettier-vscode
    # searking.preview-vscode
    ms-python.python
    matklad.rust-analyzer
    # ahmadawais.shades-of-purple
    # octref.vetur
    # tiehuis.zig
    # rubymaniac.vscode-direnv
  ];
  vscode-with-extensions = pkgs.vscode-with-extensions.override {
    vscodeExtensions = extensions;
  };
  # ;-;
  multimc-signed = pkgs.multimc.override {
    msaClientID = "81a207c0-a53c-46a3-be07-57d2b28c1643";
  };
  multimc-with-jdk11 = multimc-signed.overrideAttrs (oldAttrs: {
    postPatch = oldAttrs.postPatch + ''
      substituteInPlace launcher/java/JavaUtils.cpp \
        --replace 'scanJavaDir("/usr/java")' 'javas.append("${pkgs.jdk11}/lib/openjdk/bin/java")'
    '';
  });
in {
  # enable fontconfig
  fonts.fontconfig.enable = true;


  # packages to install for the user
  home.packages = with pkgs; [
    # applications
    ark
    mpv
    ngrok
    krita
    gthumb
    tdesktop
    keepassxc
    spectacle
    obs-studio
    dolphinEmuMaster
    element-desktop
    helio-workstation
    ungoogled-chromium
    simplescreenrecorder


    # vscode-with-extensions
    vscode

    ## development
    alacritty
    kcolorchooser
    sublime-merge

    ## gaming
    multimc-with-jdk11  

    # languages
    # TODO: uhhh, containerize these I guess..
    # Or not, setting up flakes with vscode is a pain and I use these daily anyways.
    nodejs_latest
    yarn
    ruby
    deno
    # rust components for rust analyzer integration
    rustup
    clang
    glibc
    # rustfmt
    rust-analyzer

    # cli apps (?)
    bottom
    mpc_cli

    # cli tools
    sd
    fd
    git
    exa
    bat
    ffmpeg
    httplz
    pandoc
    ripgrep
    ruplacer

    # for qdbus
    qt5.qttools

    # for cargo
    cargo-edit

    # for nix
    nixpkgs-fmt

    # extensions
    dislocker
    kmix

    # fonts
    ibm-plex
    # for telegram
    open-sans
  ];

  # enable the direnv environment loader
  programs.direnv = {
    enable = true;
    enableFishIntegration = true;
    nix-direnv.enable = true;
  };

  # configure the fish shell
  programs.fish = {
    enable = true;
    shellAliases = {
      l = "exa -l";
      ls = "exa";
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
      font.size = 8;
      window = {
        padding = {
          x = 5;
          y = 5;
        };
      };
    };
  };

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
