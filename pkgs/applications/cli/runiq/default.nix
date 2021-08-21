{ lib, stdenv, source, rustPlatform, ... }:

rustPlatform.buildRustPackage rec {
  inherit (source) src pname version; # cargoLock;

  cargoPatches = [
    ./add-Cargo.lock.patch
  ];

  cargoSha256 = "sha256-GTYyBS/xW6SEf6W0yipOloNFWmo57ZI0OeBxgjZmmEU=";

  meta = with lib; {
    description = "An efficient way to filter duplicate lines from input, à la uniq.";
    homepage = "https://github.com/whitfin/runiq";
    license = [ licenses.mit ];
    maintainers = [ maintainers.whitfin ];
    platforms = platforms.unix;
  };
}
