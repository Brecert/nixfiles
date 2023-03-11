{ lib
, stdenv
, fetchFromGitHub
# requires our updated version of odin
, odin
}:

stdenv.mkDerivation rec {
  pname = "ols";
  version = "nightly";

  src = fetchFromGitHub {
    owner = "DanielGavin";
    repo = "ols";
    rev = version;
    hash = "sha256-YUCXWL01lWiVklRQU+LkT3qrOeHbq5IrGh6A9I4IKeg=";
  };

  nativeBuildInputs = [
    odin
  ];

  buildPhase = ''
    runHook preBuild

    odin build src/ -collection:shared=src -out:ols -o:speed
    
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    mv ols $out/bin/ols
    
    runHook postInstall
  '';

  meta = with lib; {
    description = "Language server for Odin";
    homepage = "https://github.com/DanielGavin/ols";
    license = licenses.mit;
    platforms = platforms.x86_64;
  };
}