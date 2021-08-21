{ rustPlatform, fetchFromGitHub, llvmPackages_latest, source, pkgsMusl, rust, stdenv, linuxHeaders, buildPackages, rust-bin }:
let
  hostTarget = rust.toRustTargetSpec stdenv.hostPlatform;
  muslTarget = rust.toRustTargetSpec pkgsMusl.stdenv.hostPlatform;
  rustSpecific = rust-bin.stable.latest.minimal.override {
    targets = [ "x86_64-unknown-linux-musl" ];
  };
in
rustPlatform.buildRustPackage rec {
  inherit (source) pname version src;


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
    cargo build --frozen --release --target=${muslTarget} --target-dir=target
    mv target/${muslTarget}/ target/${hostTarget}
    runHook postBuild
  '';


  cargoSha256 = "sha256-abtXk6khA4UT83R9h58HW0SFTqAQYbnuWLEGDuMcRtc=";
}
