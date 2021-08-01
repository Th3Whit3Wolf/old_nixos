{ lib, pkgs, source, ... }:

let
  mkRustPlatform = pkgs.callPackage ./mk-rust-platform.nix { };
  rustPlatform = mkRustPlatform {
    date = "2021-07-15";
    channel = "nightly";
  };
in

rustPlatform.buildRustPackage rec {
  inherit (source) pname version src;

  cargoPatches = [
    # a patch file to add/update Cargo.lock in the source code
    ./update-Cargo.lock.patch
  ];
  cargoSha256 = "sha256-D3yU10Rz4vTTJbHjuYyCi/Kt1ZEMB32J93h6i38OB4w=";
  cargoBuildFlags = [ "--no-default-features" "--features=wayland" ];
  nativeBuildInputs = with pkgs; [
    pkgs.wrapGAppsHook
    pkg-config
  ];

  buildInputs = with pkgs; [
    old.gtk3
    cairo
    glib
    glib.dev
    atk
    pango
    gdk-pixbuf
    gdk-pixbuf-xlib
    wayland
    wayland-protocols
    gtk-layer-shell
    gtk-layer-shell.dev
  ];

  doCheck = false;
  checkPhase = null;

  meta = with lib; {
    description = "A standalone widget system made in Rust to add AwesomeWM like widgets to any WM";
    homepage = "https://github.com/elkowar/eww";
    license = licenses.mit;
    maintainers = with maintainers; [ fortuneteller2k ];
  };
}
