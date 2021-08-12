{ lib
, stdenv
, source
, pkgs

}:
stdenv.mkDerivation rec {
  inherit (source) pname src version;

  buildInputs = with pkgs; [
    python3
    dmidecode
  ];
  buildPhase = "make";
  installPhase = ''
    mkdir -p $out
    make DESTDIR=$out install
  '';


  meta = with lib; {
    description = "NoteBook FanControl ported to Linux";
    homepage = "https://github.com/nbfc-linux/nbfc-linux";
    license = licenses.mit;
    maintainers = [ th3whit3wolf ];
    platforms = platforms.linux;
  };
}
