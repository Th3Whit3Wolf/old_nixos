{ lib, stdenv, source, rustPlatform, ... }:

rustPlatform.buildRustPackage rec {
  inherit (source) src pname version; # cargoLock;

  cargoSha256 = "sha256-IvdV22dlC/zAzU5QaII8y5CkUkBuKCCCFOapZdjonh0=";

  meta = with lib; {
    description = "A Fast Documentation Searcher for Nix";
    homepage = "https://github.com/mlvzk/manix";
    license = [ licenses.mpl20 ];
    maintainers = [ maintainers.mlvzk ];
    platforms = platforms.unix;
  };
}
