{ lib, stdenv, source, rustPlatform, ... }:

rustPlatform.buildRustPackage rec {
  inherit (source) src pname version;

  cargoSha256 = "sha256-LiEeAYQEQ6i8s1gMlyJvRl3fg+jFlkFBUQ5HyllUzco=";

  meta = with lib; {
    description = "A fast memory safe alternative to cp.";
    homepage = "https://github.com/arijit79/cn";
    license = [ licenses.mit ];
    maintainers = [ maintainers.arijit79 ];
    platforms = platforms.unix;
  };
}
