{ lib
, stdenv
, fetchzip
, autoPatchelfHook
, makeWrapper
, makeDesktopItem
, copyDesktopItems
, pkg-config
, fontconfig
, glib
, gtk3
, freetype
, openssl
, xorg
, libGL
, withGui ? false # build GUI version
}:

stdenv.mkDerivation rec {
  pname = if withGui then "rusty-psn-gui" else "rusty-psn";
  version = "0.3.6";

  src = fetchzip {
    url = "https://github.com/RainbowCookie32/rusty-psn/releases/download/v${version}/rusty-psn-egui-linux.zip";
    hash = "sha256-IwJLVWu77NhFoBUEAL960S2/wvqa/yWRddx9cQsMURM=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
  ] ++ lib.optionals withGui [
    copyDesktopItems
  ];

  buildInputs = [
    openssl
  ] ++ lib.optionals withGui [
    fontconfig
    glib
    gtk3
    freetype
    openssl
    xorg.libxcb
    xorg.libX11
    xorg.libXcursor
    xorg.libXrandr
    xorg.libXi
    xorg.libxcb
    libGL
    libGL.dev
  ];

  installPhase = ''
    runHook preInstall

    install -m755 -D rusty-psn $out/bin/${pname}

    runHook postInstall
  '';

  postInstall = ''
    wrapProgram "$out/bin/${pname}" \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath buildInputs}
  '';

  desktopItem = lib.optionalString withGui (makeDesktopItem {
    name = "rusty-psn";
    desktopName = "rusty-psn";
    exec = pname;
    comment = "A simple tool to grab updates for PS3 games, directly from Sony's servers using their updates API.";
    categories = [
      "Network"
    ];
    keywords = [
      "psn"
      "ps3"
      "sony"
      "playstation"
      "update"
    ];
  });
  desktopItems = lib.optionals withGui [ desktopItem ];

  meta = with lib; {
    description = "Simple tool to grab updates for PS3 games, directly from Sony's servers using their updates API";
    homepage = "https://github.com/RainbowCookie32/rusty-psn/";
    license = licenses.mit;
    platforms = [ "x86_64-linux" ];
  };
}