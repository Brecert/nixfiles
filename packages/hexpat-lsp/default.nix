{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "hexpat-lsp";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "Calcoph";
    repo = "hexpat-lsp";
    rev = "v${version}";
    hash = "sha256-Ypetxmil/LYiKeeaiZvj6ZBluPbirmrPIe1YdYZbc6o=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "nom-locate-4.0.0" = "sha256-c+riMC1xaLYCmADS8q7OG8lWKjAwH51kO/niJxIjC88=";
    };
  };

  meta = with lib; {
    description = "Language Server Provider for ImHex's pattern language";
    homepage = "https://github.com/Calcoph/hexpat-lsp.git";
    changelog = "https://github.com/Calcoph/hexpat-lsp/blob/${src.rev}/CHANGELOG.md";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ ];
  };
}
