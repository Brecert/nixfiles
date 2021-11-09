{ config, lib, pkgs, ... }:
{
  home.packages = with pkgs; lib.flatten [
    # Apps
    # > general use applications, generally with a gui
    [
      mpv
      ngrok
      krita
      gthumb
      tdesktop
      keepassxc
      obs-studio
      apostrophe
      element-desktop
      dolphinEmuMaster
      helio-workstation
      ungoogled-chromium
      simplescreenrecorder
    ]

    ## Development
    ## > apps intended for use with development
    [
      alacritty
      kcolorchooser
      sublime-merge
      vscode
    ]

    ## Gaming
    ## > apps associated and intended for gaming
    (
      let
        multimc-signed = pkgs.multimc.override { msaClientID = "81a207c0-a53c-46a3-be07-57d2b28c1643"; };
        multimc-with-jdk11 = multimc-signed.overrideAttrs (oldAttrs: {
          postPatch = oldAttrs.postPatch + ''
            substituteInPlace launcher/java/JavaUtils.cpp \
              --replace 'scanJavaDir("/usr/java")' 'javas.append("${pkgs.jdk11}/lib/openjdk/bin/java")'
          '';
        });
      in
      [ multimc-with-jdk11 ]
    )

    # Programming Languages
    # > while consistency and eventual reproducability is an important goal,
    #   I use these languages often enough, and in isolation ( without touching external dependencies )
    #   that "containerizing" them every time is not wanted.
    # 
    # node/todo: with nix templates, and improvements to the devshell and setting up a project, the above reasons will be less of an issue.  
    [
      nodejs_latest
      yarn
      ruby
      deno

      # Rust
      [
        rust-analyzer
        rustup
        clang
        glibc

        # adds `cargo add`
        cargo-edit
      ]

      # Nix
      [
        nixpkgs-fmt
      ]
    ]
    ## components for rust analyzer integration

    # Command line tooling
    # > tools meant for use in or with the command line
    [
      steam-run-native
      ruplacer
      ripgrep
      bottom
      ffmpeg
      httplz
      pandoc
      bat
      exa
      fd
      sd
    ]

    # Fonts
    [
      # for sublime text writer profile
      ibm-plex

      # for telegram
      open-sans
    ]

    # Gnome
    [ gnomeExtensions.appindicator ]

    # Drivers / Extensions
    [
      # used for accessing the shared partition
      dislocker
    ]
  ];
}
