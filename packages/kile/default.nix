{ lib, pkgs, fetchgit }:

with pkgs;

rustPlatform.buildRustPackage rec {
  pname = "kile";
  version = "v0.1.0_Apr-11-2021";

  src = fetchgit {
    url = "https://gitlab.com/snakedye/kile.git";
    rev = "ce2373371d97181d21840963c4bf70bd864cfe41";
    sha256 = "nIEoeAEjjSAWjehYc9XXSThsbOn/aWPDMCOj0dtBACg=";
  };

  cargoPatches = [ ./add-cargo-lock.patch ];

  nativeBuildInputs = [ pkg-config rust-bin.nightly.latest.rust ];

  buildInputs = [
    wayland-protocols
  ];

  checkPhase = null;
  cargoSha256 = "sha256-zXz47yIY8WXVolVooOi5N/+BUW2JKzOAX/bumRyeq78=";

  meta = with lib; {
    description =
      "Layout generator for river";
    homepage = "https://gitlab.com/snakedye/kile";
    license = licenses.mit;
    maintainers = with maintainers; [ fortuneteller2k ];
  };
}
