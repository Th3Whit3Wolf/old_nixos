{ lib, pkgs, stdenv, ... }:

let
  pname = "frawk";
  version = "0.4.1";
  src = builtins.fetchTarball {
    url = "https://github.com/ezrosent/${pname}/releases/download/v${version}/linux-x86-musl-no-llvm.tar.gz";
    sha256 = "0hdhfcmvrgsj5znkrkdnhswzam22816w7gicpj6myv7f54g8x6lq";
  };
in

stdenv.mkDerivation rec {
  inherit pname version src;


  phases = [ "installPhase" "patchPhase" ];
  installPhase = ''
    mkdir -p $out/bin
    cp $src $out/bin/frawk
    chmod +x $out/bin/frawk
  '';

  meta = with lib; {
    description = "An efficient awk like language.";
    homepage = "https://github.com/ezrosent/frawk";
    license = [ licenses.mit ];
    maintainers = [ maintainers.ezrosent ];
    platforms = platforms.unix;
  };
}



