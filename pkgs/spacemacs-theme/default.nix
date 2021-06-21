{ lib, stdenv, srcs }:
let src = srcs.spacemacs-theme;
in stdenv.mkDerivation {
  inherit src;
  inherit (src) pname version;

  buildPhase = "true";

  installPhase = ''
    for theme in $(ls themes); do
        mkdir -p $out/share/{icons,themes}/$theme
        cp -R themes/$theme/* $out/share/themes/$theme/
        cp -R icons/$theme/* $out/share/icons/$theme/
    done
  '';

  meta = with lib; {
    description = "Spacemacs theme for linux";
    homepage = "https://github.com/Th3Whit3Wolf/Space-Theme/";

    maintainers = [ maintainers.Th3Whit3Wolf ];
    platforms = platforms.unix;
    license = licenses.mit;
    inherit version;
  };
}
