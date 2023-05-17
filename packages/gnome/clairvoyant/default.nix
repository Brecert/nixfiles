{ lib
, stdenv
, fetchFromGitHub
, nix-update-script
, meson
, ninja
, wrapGAppsHook4
, vala
, pkg-config
, cmake
, libadwaita
, desktop-file-utils
, python3
, gtk4
, gtk3
}:

stdenv.mkDerivation rec {
  pname = "clairvoyant";
  version = "3.0.6";

  src = fetchFromGitHub {
    owner = "cassidyjames";
    repo = "clairvoyant";
    rev = version;
    hash = "sha256-QJNW9fTbbFkT7utn8z4TYqnXMfMVmNxWiYen7be2ZwY=";
  };

  nativeBuildInputs = [
    desktop-file-utils
    meson
    ninja
    pkg-config
    python3
    vala
    wrapGAppsHook4
  ];

  buildInputs = [
    gtk4
    libadwaita
  ];

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py

    substituteInPlace meson/post_install.py \
      --replace "gtk-update-icon-cache" "gtk4-update-icon-cache"
  '';

  postInstall = ''
    mv $out/bin/com.github.cassidyjames.clairvoyant $out/bin/clairvoyant
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Magic 8-Ball fortune teller of sorts";
    homepage = "https://github.com/cassidyjames/clairvoyant";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ ];
  };
}
