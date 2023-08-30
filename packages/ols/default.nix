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
    rev = "a72ac2941a1a54e05b4051a00ca25b0b3822b1c6";
    hash = "sha256-8U/MHaVQDXWhhUqVSZvMu3JrVQpjYhmEIXwqyh9ipyE=";
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