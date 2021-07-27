{
  description = "Modules to help developers get work done";

  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { nixpkgs, flake-utils, ... }@inputs:
    let
      inherit (flake-utils.lib) eachDefaultSystem eachSystem;
    in
    eachDefaultSystem
      (system:
        let
          pkgs = import nixpkgs { inherit system; };
        in
        {
          devShell = pkgs.mkShell { buildInputs = [ (pkgs.python3.withPackages (ps: with ps; [ PyGithub ])) ]; };
        }) //
    eachSystem [ "x86_64-linux" ]
      (system: {
        hmModule = import ./modules/home-manager/default.nix inputs;
      });
}

