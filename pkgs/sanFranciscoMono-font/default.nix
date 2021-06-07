{ lib, stdenv, srcs }:
let src = srcs.sanFranciscoMono-font;
in
stdenv.mkDerivation {
  inherit src;
  inherit (src) pname version;

  buildPhase = "true";

  installPhase = ''
    mkdir -p $out/share/fonts/san-francisco-mono
    cp *.otf $out/share/fonts/san-francisco-mono
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
