{ lib, stdenv, source, rustPlatform, ... }:

rustPlatform.buildRustPackage rec {
  inherit (source) src pname version;

  cargoSha256 = "sha256-4VQd/5HB4syywiTovGJCrEX38wB1P2S27fvOla4A47U=";

  meta = with lib; {
    description = "A comically fast way of indexing and querying your filesystem.";
    homepage = "https://github.com/ngirard/lolcate-rs";
    license = [ licenses.mit ];
    maintainers = [ maintainers.ngirard ];
    platforms = platforms.unix;
  };
}
