{ lib
, stdenv
, fetchurl
, fetchFromGitHub
, makeDesktopItem
, makeWrapper
, copyDesktopItems
, pkgs
# Dolphin
, vulkan-loader
, xdg_utils
, mesa
, pkg-config
, bluez
, ffmpeg_4
, libao
, libGLU
, gettext
, xorg
, readline
, openal
, libevdev
, portaudio
, libusb1
, libpulseaudio
, udev
, gnumake
, soundtouch
, miniupnpc
, mbedtls
, curl
, lzo
, sfml
, enet
, hidapi
, webkitgtk
# GTK
, gtk3
, gtk2
, glib
, glib-networking
, gdk-pixbuf
}:

let
  # it's like this for faster iteration
  dolphin-emu = stdenv.mkDerivation rec {
    pname = "dolphin-emu";
    version = "3.0.4";

    src = fetchFromGitHub {
      owner = "project-slippi";
      repo = "Ishiiruka";
      rev = "v3.0.4";
      sha256 = "sha256-8zORxpbeRtn7Xrb2NwYTuSsw3m9CWe1v0LBT4Du29F4=";
    };

    cmakeFlags = [
      "-DLINUX_LOCAL_DEV=true"
      "-DGTK3_GLIBCONFIG_INCLUDE_DIR=${glib.out}/lib/glib-3.0/include"
      "-DGTK3_GLIBCONFIG_INCLUDE_DIR=${glib-networking.out}/lib/glib-3.0/include"
      "-DGTK3_GDKCONFIG_INCLUDE_DIR=${gtk3.out}/lib/gtk-3.0/include"
      "-DGTK3_INCLUDE_DIRS=${gtk3.out}/lib/gtk-3.0"
      "-DENABLE_LTO=True"
      "-DGTK2_GLIBCONFIG_INCLUDE_DIR=${glib.out}/lib/glib-2.0/include"
      "-DGTK2_GLIBCONFIG_INCLUDE_DIR=${glib-networking.out}/lib/glib-2.0/include"
      "-DGTK2_GDKCONFIG_INCLUDE_DIR=${gtk2.out}/lib/gtk-2.0/include"
      "-DGTK2_INCLUDE_DIRS=${gtk2}/lib/gtk-2.0"
    ];

    nativeBuildInputs = with pkgs; [
      cmake
      gnumake
      pkg-config
      wrapGAppsHook
    ];

    buildInputs = with pkgs; [
      bluez
      curl
      enet
      ffmpeg_4
      # wxGTK30
      gdk-pixbuf
      gettext
      glib
      glib-networking
      gtk2
      gtk3
      hidapi
      libao
      libevdev
      libGLU
      libpulseaudio
      libusb1
      lzo
      mbedtls
      mesa
      mesa.drivers
      miniupnpc
      openal
      portaudio
      readline
      sfml
      soundtouch
      udev
      vulkan-loader
      webkitgtk
      xdg_utils
      xorg.libpthreadstubs
      xorg.libSM
      xorg.libX11
      xorg.libXdmcp
      xorg.libXext
      xorg.libXrandr
    ];

    postBuild = ''
      cp -r -n ../Data/Sys/ Binaries/
      cp -r Binaries/ $out
      mkdir -p $out/bin
    '';
  };

  icons = fetchurl {
    url = "https://github.com/project-slippi/slippi-launcher/raw/v2.9.0/assets/icon.ico";
    sha256 = "sha256-SHIrMerIkvORKY1knRnFZr2NKny+3MVgyjKNHapo9Os=";
  };
in
stdenv.mkDerivation rec {
  pname = "slippi-netplay";
  version = "3.0.4";

  src = dolphin-emu;

  nativeBuildInputs = [
    makeWrapper
    copyDesktopItems
    pkgs.tree
    pkgs.iconConvTools
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "Slippi-Netplay";
      desktopName = "Slippi Online";
      genericName = "Wii/GameCube Emulator";
      exec = "slippi-netplay";
      icon = "slippi-netplay";
      comment = "Play Melee Online!";
      categories = [ "Game" "Emulator" ];
      keywords = [ "Melee" ];
      startupNotify = false;
    })
  ];

  installPhase = ''
    mkdir $out
    
    cp -r * $out

    wrapProgram "$out/dolphin-emu" \
      --set "GDK_BACKEND" "x11" \
      --prefix GIO_EXTRA_MODULES : "${glib-networking}/lib/gio/modules" \
      --prefix LD_LIBRARY_PATH : "${vulkan-loader}/lib" \
      --prefix PATH : "${xdg_utils}/bin"
    
    ln -s $out/dolphin-emu $out/bin/slippi-netplay
    
    icoFileToHiColorTheme ${icons} slippi-netplay $out

    runHook postInstall
  '';

  meta = with lib; {
    description = "The way to play Slippi Online and watch replays";
    homepage = "https://github.com/project-slippi/slippi-launcher.git";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ ];
  };
}