{ lib
, stdenv
, fetchFromGitHub
, gnumake
, perl
, SDL2
, zlib
, libpng
, tree
}:

stdenv.mkDerivation rec {
  pname = "ue-viewer";
  version = "4.27";

  src = fetchFromGitHub {
    owner = "gildor2";
    repo = "UEViewer";
    rev = "ue${version}";
    hash = "sha256-C5jbHubBYREZxolFQCHAVmjDo7zb8VNXKyQt0rEdnH8=";
  };

  nativeBuildInputs = [
    gnumake
    perl
    tree
  ];

  buildInputs = [
    SDL2
    zlib
    libpng
  ];

  postPatch = ''
    patchShebangs .
  '';

  buildPhase = ''
    runHook preBuild

    bash build.sh
  
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    mv umodel $out/bin

    runHook postInstall
  '';

  meta = with lib; {
    description = "Viewer and exporter for Unreal Engine 1-4 assets (UE Viewer";
    homepage = "https://github.com/gildor2/UEViewer.git";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ ];
  };
}
