{ lib, stdenv, sources, ... }:

stdenv.mkDerivation rec {
  inherit (sources.sanFrancisco-font) src pname version;

  buildPhase = "true";

  installPhase = ''
    mkdir -p $out/share/fonts/san-francisco
    cp *.ttf $out/share/fonts/san-francisco
  '';

  meta = with lib; {
    description = "Yosemite San Francisco Font by Apple";
    homepage = "https://github.com/supermarin/YosemiteSanFranciscoFont";

    maintainers = [ maintainers.Th3Whit3Wolf ];
    platforms = platforms.unix;
    license = licenses.mit;
    inherit version;
  };
}
