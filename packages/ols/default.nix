{ lib
, stdenv
, fetchFromGitHub
# requires our updated version of odin
, odin
}:

stdenv.mkDerivation {
  pname = "ols";
  version = "nightly";

  src = fetchFromGitHub {
    owner = "DanielGavin";
    repo = "ols";
    rev = "2b0dccaa496fd809e36e7d979995e843bca28bfb";
    hash = "sha256-DWcQinFqSomDQyxAi60x9mXVT2JzrQJUi9qisVOlueo=";
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