{ lib
, stdenv
, fetchurl
, appimageTools
, curl
}:

appimageTools.wrapType2 rec {
  pname = "slippi-launcher";
  version = "2.9.0";

  src = fetchurl {
    url = "https://github.com/project-slippi/slippi-launcher/releases/download/v${version}/Slippi-Launcher-${version}-x86_64.AppImage";
    hash = "sha256-SxjNP4N/f/FSg4Dq3WyyD/n64kcXnedd44bfapdm94Y=";
  };

  extraPkgs = pkgs: [
    curl
  ];
  
  meta = with lib; {
    description = "Slippi frontend for launching slippi online and managing slippi replays";
    homepage = "https://github.com/project-slippi/slippi-launcher";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ ];
  };
}
