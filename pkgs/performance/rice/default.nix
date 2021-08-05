{ lib, pkgs, source, rustPlatform, rust-bin, fetchFromGitHub, ... }:

let
  #rustSpecific = rust-bin.stable.latest.minimal.override {
  #    targets = [ "x86_64-unknown-linux-musl" ];
  #};
  #rustc = rustSpecific;
  #cargo = rustSpecific;
  #rustPlatform = makeRustPlatform { inherit cargo rustc; };
  Ananicy = fetchFromGitHub {
    repo = "Ananicy";
    owner = "Nefelim4ag";
    rev = "2.2.1";
    sha256 = "sha256-++vxAYMCUuvNRYbyWabkfy++io2h/R7mwInFjMwNRro=";
  };
in



rustPlatform.buildRustPackage rec {
  inherit (source) pname version src;

  cargoPatches = [
    ./add-Cargo.Lock.patch
    ./modify-Cargo.toml.patch
    ./modify-src.patch
  ];

  cargoSha256 = "sha256-ehqdar57S0KOneTX3SWvoPorI+xeL4zBLKiPrz7lPH0=";
  cargoBuildFlags = [ "--no-default-features" "--features=syslog" ];
  #CARGO_BUILD_RUSTFLAGS = "-C target-feature=+crt-static";
  #CARGO_TARGET_X86_64_UNKNOWN_LINUX_MUSL_LINKER = "${[kgs].llvmPackages_10.lld}/bin/lld";

  #target = "x86_64-unknown-linux-musl";
  nativeBuildInputs = with pkgs; [
    pkg-config
  ];

  buildInputs = with pkgs; [
    pkg-config
  ];

  postInstall = ''
    mkdir -p $out/{bin,rules}
    mv target/x86_64-unknown-linux-gnu/release/rice-bin $out/bin/rice
    cp -r ${Ananicy}/ananicy.d/* $out/rules/
    strip --strip-all $out/bin/rice
    chmod +x $out/bin/rice
  '';

  doCheck = false;
  checkPhase = null;

  meta = with lib; {
    description = "A standalone widget system made in Rust to add AwesomeWM like widgets to any WM";
    homepage = "https://github.com/elkowar/eww";
    license = licenses.mit;
  };
}
