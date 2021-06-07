{ lib, stdenv, srcs }:
let src = srcs.sanFrancisco-font;
in
stdenv.mkDerivation {
  inherit src;
  inherit (src) pname version;

  buildPhase = "true";

  installPhase = ''
    for font in *.ttf; do 
        mkdir -p $out/share/fonts/
        name=$(echo $font | sed 's/System //')
        cp $font $out/share/fonts/$name
    done
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
