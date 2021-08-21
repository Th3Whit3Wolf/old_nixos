{ lib, stdenv, source, rustPlatform, ... }:

rustPlatform.buildRustPackage rec {
  inherit (source) src pname version; # cargoLock;

  cargoSha256 = "sha256-yKU4+F/8thlZ5smKjSaNxrHHQg1Qv0V5arDRUUjBTHw=";

  meta = with lib; {
    description = "Find files (ff) by name, fast!";
    homepage = "https://github.com/vishaltelangre/ff";
    license = [ licenses.unlicense ];
    maintainers = [ maintainers.vishaltelangre ];
    platforms = platforms.unix;
  };
}
