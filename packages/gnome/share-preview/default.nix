{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, rustc
, cargo
, pkg-config
, meson
, ninja
, wrapGAppsHook4
, openssl
, libadwaita
, desktop-file-utils
}:

stdenv.mkDerivation rec {
  pname = "share-preview";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "rafaelmardojai";
    repo = pname;
    rev = version;
    sha256 = "sha256-CsnWQxE2r+uWwuEzHpY/lpWS5i8OXvhRKvy2HzqnQ5U=";
  };

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = "${src}/Cargo.lock";
  };

  nativeBuildInputs = [
    # Gnome Inputs
    meson
    ninja
    pkg-config
    wrapGAppsHook4
    
    # Rust Inputs
    rustPlatform.cargoSetupHook
    cargo
    rustc

    # Project Inputs
    openssl
  ];

  buildInputs = [
    libadwaita
    desktop-file-utils
  ];

  meta = with lib; {
    description = "Test social media cards locally";
    homepage = "https://github.com/rafaelmardojai/share-preview.git";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ ];
  };
}