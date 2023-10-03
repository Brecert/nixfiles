{ lib
, fetchurl
, appimageTools
, makeDesktopItem
, iconConvTools
}:

let
  pname = "slippi-online";
  version = "3.3.0";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://github.com/project-slippi/Ishiiruka/releases/download/v${version}/Slippi_Online-x86_64.AppImage";
    hash = "sha256-rI1SInSqyl6XqbwusfIdVokQORzDovL6P7G8l0x0s1E=";
  };

  icons = fetchurl {
    url = "https://github.com/project-slippi/slippi-launcher/raw/v2.10.5/assets/icon.ico";
    sha256 = "sha256-SHIrMerIkvORKY1knRnFZr2NKny+3MVgyjKNHapo9Os=";
  };

  desktopItem = makeDesktopItem {
    name = "slippi-online";
    desktopName = "Slippi Online";
    genericName = "Wii/GameCube Emulator";
    exec = "slippi-online";
    icon = "slippi-online";
    comment = "Play Melee Online!";
    categories = [ "Game" "Emulator" ];
    keywords = [ "Melee" ];
    startupNotify = false;
  };

  appimageContents = appimageTools.extractType2 { inherit name src; };
in

appimageTools.wrapType2 rec {
  inherit name src;

  extraPkgs = pkgs: with pkgs; [
      # runtime
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

  extraInstallCommands = ''
    mv $out/bin/${name} $out/bin/${pname}

    mkdir -p $out/share/applications/
    cp ${desktopItem}/share/applications/* $out/share/applications
    
    ${iconConvTools}/bin/icoFileToHiColorTheme ${icons} ${pname} $out
  '';

  meta = with lib; {
    description = "The way to play Slippi Online and watch replays";
    homepage = "https://github.com/project-slippi/slippi-launcher.git";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ ];
  };
}