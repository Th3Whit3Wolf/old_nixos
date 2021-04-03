{ pkgs ? import <nixpkgs> { } }:

with pkgs;
let
  nixBin = writeShellScriptBin "nix" ''
    ${nixFlakes}/bin/nix --option experimental-features "nix-command flakes" "$@"
  '';
in mkShell {
  nativeBuildInputs = [ cmake pkgconfig ];
  buildInputs = [ git nix-zsh-completions rustc cargo libopus ffmpeg fmt ];
  shellHook = ''
    export FLAKE="$(pwd)"
    export PATH="$FLAKE/bin:${nixBin}/bin:$PATH"
  '';
}
