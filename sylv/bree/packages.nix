{ config, pkgs, ... }: 
let
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
  imports = [
    ./programs.nix
  ];

  # enable fontconfig
  fonts.fontconfig.enable = true;

  # packages to install for the user
  home.packages = with pkgs; [
    # applications
    # ark
    mpv
    ngrok
    krita
    gthumb
    tdesktop
    keepassxc
    obs-studio
    apostrophe
    # spectacle
    element-desktop
    dolphinEmuMaster
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
    steam-run-native
    multimc-with-jdk11
    # airshipper

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

    # fonts
    # for sublime text writer profile
    ibm-plex
    # for telegram
    open-sans
  ];
}
