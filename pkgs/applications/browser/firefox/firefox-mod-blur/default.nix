{ lib, stdenv, source }:
stdenv.mkDerivation rec {
  inherit (source) pname src version;

  installPhase = ''
    mkdir -p $out/chrome
    cp -r ./ $out/chrome
  '';

  meta = with lib; {
    description = "Firefox Proton - Blur Mod / For dark theme lovers / Blurred search and bookmarks bar";
    homepage = "https://github.com/datguypiko/Firefox-Mod-Blur";
    license = licenses.mit;
    maintainers = [ th3whit3wolf ];
    platforms = platforms.all;
  };
}
