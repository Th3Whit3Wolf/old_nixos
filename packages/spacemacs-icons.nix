{ stdenv, lib, fetchurl }:

stdenv.mkDerivation rec {
  version = "2015-06-25";
  name = "Space-Theme";
  at = "f3dbdfba0207e7bb7a14f9e925c31c113eb11563";

  src = fetchurl {
    url = "https://github.com/Th3Whit3Wolf/Space-Theme/archive/${at}.tar.gz";
    sha256 = "Okp9GcLWK0if5/KsgPCkFSeC8UJ7R72VVa48mgKX5r4=";
  };

  phases = [ "unpackPhase" "installPhase" ];

  installPhase = ''
    for icon in $(ls icons); do
      mkdir -p $out/share/icons/$icon
      #chmod 755 icons/$icon/index.icon
      sed '/s/oomox//g' icons/$icon/index.theme
      cp -R icons/$icon/* $out/share/icons/$icon/
    done
  '';

  meta = {
    description = "Spacemacs icons for spacemacs theme";
    homepage = "https://github.com/Th3Whit3Wolf/Space-Theme";
    license = lib.licenses.asl20;
    platforms = lib.platforms.all;
    maintainers = [ ];
  };
}
