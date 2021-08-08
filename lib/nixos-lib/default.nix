{ lib }:
{
  mkFirefoxUserJs = import ./mkFirefoxUserJs.nix { inherit lib; };
}
