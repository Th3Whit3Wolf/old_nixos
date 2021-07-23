{ lib, stdenv, source }:

stdenv.mkDerivation rec {
  inherit (source) src pname version;
  buildPhase = "true";

  installPhase = ''
    mkdir -p $out/share/fonts/SFMono
    cp *.otf $out/share/fonts/SFMono
  '';

  meta = with lib; {
    description = "Apple's SF Mono font patched with the Nerd Fonts patcher";
    homepage = "https://github.com/epk/SF-Mono-Nerd-Font";

    maintainers = [ maintainers.Th3Whit3Wolf ];
    platforms = platforms.unix;
    license = licenses.mit;
    inherit version;
  };
}
