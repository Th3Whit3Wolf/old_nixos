{
  description = "Modules to help developers get work done";

  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    utils.url = "github:numtide/flake-utils";
    rust-overlay.url = "github:oxalica/rust-overlay";
  };

  outputs = { nixpkgs, flake-utils, rust-overlay, ... }:
    utils.lib.eachDefaultSystem (system:
      let

        overlays = [
          rust-overlay.overlay
          (self: super:
            let
              rust-stable = pkgs.rust-bin.stable.latest.default.override {
                extensions =
                  [ "cargo" "clippy" "rust-docs" "rust-src" "rust-std" "rustc" "rustfmt" ];
              };
            in
            {
              rustc = rust-stable;
              cargo = rust-stable;
              clippy = rust-stable;
              rustfmt = rust-stable;
            })
        ];

        pkgs = import nixpkgs {
          inherit system overlays;
        };

        devShell = pkgs.mkShell {
          buildInputs = [
            cargo
          ];
        };

        ) //
        eachSystem [ "x86_64-linux" ]
        (system: {
        hmModule = import ./modules/home-manager/default.nix;
        });
        }

