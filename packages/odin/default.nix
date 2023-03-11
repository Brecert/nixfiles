{ lib
, fetchFromGitHub
, llvmPackages_13
, makeWrapper
, git
, which
}:

let
  inherit (llvmPackages_13) stdenv bintools llvm clang lld;
in
stdenv.mkDerivation rec {
  pname = "odin";
  version = "dev-2023-03";

  src = fetchFromGitHub {
    owner = "odin-lang";
    repo = "Odin";
    rev = version;
    sha256 = "sha256-SIU1VZgac0bL6byai2vMvgl3nrWZaU9Hn0wRqazzxn4=";
  };

  nativeBuildInputs = [
    git
    makeWrapper
    which
    llvm
  ];

  dontConfigure = true;

  postPatch = ''
    patchShebangs ./build_odin.sh
    sed -i 's/^GIT_SHA=.*$/GIT_SHA=/' ./build_odin.sh
  '';

  buildFlags = [
    "release"
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp odin $out/bin/odin
    cp -r core $out/bin/core
    wrapProgram $out/bin/odin --prefix PATH : ${lib.makeBinPath [
      bintools
      llvm
      clang
      lld
    ]}

    runHook postInstall
  '';

  meta = with lib; {
    description = "A fast, concise, readable, pragmatic and open sourced programming language";
    homepage = "https://odin-lang.org/";
    license = licenses.bsd2;
    platforms = platforms.x86_64;
  };
}