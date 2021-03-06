{ lib, stdenv, source }:
stdenv.mkDerivation rec {
  inherit (source) pname src version;

  installPhase = ''
    mkdir -p $out/chrome
    cp -r ./ $out/chrome
  '';

  meta = with lib; {
    description = "It's like Photon, but better.";
    homepage = "https://github.com/1280px/rainfox";
    license = licenses.mit;
    maintainers = [ th3whit3wolf ];
    platforms = platforms.all;
  };
}
