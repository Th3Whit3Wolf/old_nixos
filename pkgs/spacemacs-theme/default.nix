{ lib, srcs, stdenv, ... }:

let src = srcs.spacemacs-theme; in

stdenv.mkDerivation {
  inherit (src) pname version;
  inherit src;

  installPhase = ''
    for theme in $(ls themes); do
        mkdir -p $out/share/{icons,themes}/$theme
        cp -R themes/$theme/* $out/share/themes/$theme/
        cp -R icons/$theme/* $out/share/icons/$theme/
    done
  '';

  meta = with lib; {
    inherit version;
    description = "Spacemacs theme for linux";
    homepage = "https://github.com/Th3Whit3Wolf/Space-Theme/";
    maintainers = [ maintainers.whitewolf ];
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
