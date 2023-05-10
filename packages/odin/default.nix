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
  version = "dev-2023-05";

  src = fetchFromGitHub {
    owner = "odin-lang";
    repo = "Odin";
    rev = version;
    sha256 = "sha256-qEewo2h4dpivJ7D4RxxBZbtrsiMJ7AgqJcucmanbgxY=";
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