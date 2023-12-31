{ lib
, fetchzip
, stdenv
}:

let
  version = "2.0.0";
  
  fetchVariant = variant: hash: fetchzip ({
    name = variant;
    url = "https://github.com/ful1e5/fuchsia-cursor/releases/download/v${version}/${variant}.tar.gz";
    hash = hash;
  });

  srcs = [
    (fetchVariant "Fuchsia" "sha256-bgEQ/l56TaxUdMB3iyJsMuLuc33mu5KMljPl2iSFNB4=")
    (fetchVariant "Fuchsia-Pop" "sha256-BvVE9qupMjw7JRqFUj1J0a4ys6kc9fOLBPx2bGaapTk=")
    (fetchVariant "Fuchsia-Red" "sha256-i91RzcANAfuaYEywaIzAnrpUl+8VhvLxQrn3NhCVNRA=")
  ];
in 
  stdenv.mkDerivation {
    pname = "fuchsia-cursor";
    inherit version;
    inherit srcs;

    sourceRoot = ".";

    installPhase = ''
      install -dm 0755 $out/share/icons
      cp -r Fuchsia* $out/share/icons/
    '';

    meta = with lib; {
      description = "Opensource Fuchsia cursors";
      homepage = "https://github.com/ful1e5/fuchsia-cursor";
      license = licenses.gpl3;
      platforms = platforms.linux;
    };
  }