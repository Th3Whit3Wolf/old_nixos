{ lib, stdenv, source, rustPlatform, darwin, Security }:

rustPlatform.buildRustPackage rec {
  inherit (source) src pname version;

  buildInputs = lib.optionals stdenv.isDarwin [ Security ];

  cargoSha256 = "1yivx9vzk2fvncvlkwq5v11hb9llr1zlcmy69y12q6xnd9rd8x1b";

  meta = with lib; {
    description = "A Fast Documentation Searcher for Nix";
    homepage = "https://github.com/mlvzk/manix";
    license = [ licenses.mpl20 ];
    maintainers = [ maintainers.mlvzk ];
    platforms = platforms.unix;
  };
}
