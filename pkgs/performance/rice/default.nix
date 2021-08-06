{ rustPlatform, fetchFromGitHub, llvmPackages_latest, source, pkgsMusl, rust, stdenv, linuxHeaders, buildPackages, rust-bin }:
let
  hostTarget = rust.toRustTargetSpec stdenv.hostPlatform;
  muslTarget = rust.toRustTargetSpec pkgsMusl.stdenv.hostPlatform;
  rustSpecific = rust-bin.stable.latest.minimal.override {
    targets = [ "x86_64-unknown-linux-musl" ];
  };
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
  nativeBuildInputs = [
    buildPackages.pkg-config
    rustSpecific
  ];
  buildInputs = [
    linuxHeaders
  ];

  # There are no tests to run
  doCheck = false;
  CARGO_TARGET_X86_64_UNKNOWN_LINUX_MUSL_LINKER = "${llvmPackages_latest.lld}/bin/lld";
  LIBCLANG_PATH = "${llvmPackages_latest.libclang.lib}/lib";

  buildPhase = ''
    runHook preBuild
    export BINDGEN_EXTRA_CLANG_ARGS=$NIX_CFLAGS_COMPILE
    export RUSTFLAGS="-C target-feature=+crt-static -C link-arg=-s"
    cargo build --frozen --release --target=${muslTarget} --target-dir=target --no-default-features --features=syslog
    mv target/${muslTarget}/ target/${hostTarget}
    runHook postBuild
  '';

  postInstall = ''
    mkdir -p $out/{bin,rules}
    mv $out/bin/rice-bin $out/bin/rice
    cp -r ${Ananicy}/ananicy.d/* $out/rules/
    chmod +x $out/bin/rice
  '';
  cargoSha256 = "sha256-ehqdar57S0KOneTX3SWvoPorI+xeL4zBLKiPrz7lPH0=";
}
