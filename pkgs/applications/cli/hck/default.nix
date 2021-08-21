{ lib, stdenv, source, rustPlatform, ... }:

rustPlatform.buildRustPackage rec {
  inherit (source) src pname version;

  cargoSha256 = "sha256-+XVE4DlR/T98Vpkg1lPmXCveM68S7oHojRhN5YW9F2I=";

  meta = with lib; {
    description = " A sharp cut(1) clone.";
    homepage = "https://github.com/sstadick/hck";
    license = [ licenses.unlicense ];
    maintainers = [ maintainers.ngirard ];
    platforms = platforms.unix;
  };
}
