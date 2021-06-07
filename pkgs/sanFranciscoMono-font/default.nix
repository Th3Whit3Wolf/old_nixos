{ lib, stdenv, srcs }:
let src = srcs.sanFranciscoMono-font;
in
stdenv.mkDerivation {
  inherit src;
  inherit (src) pname version;

  buildPhase = "true";

  installPhase = ''
    for font in *.ttf; do 
        mkdir -p $out/share/fonts/
        name=$(echo $font | sed 's/SFMono-/San Francisco Mono/')
        cp $font $out/share/fonts/$name
    done
  '';

  meta = with lib; {
    description = "San Francisco Mono Font by Apple";
    homepage = "https://github.com/supercomputra/SF-Mono-Font";

    maintainers = [ maintainers.Th3Whit3Wolf ];
    platforms = platforms.unix;
    license = licenses.mit;
    inherit version;
  };
}
