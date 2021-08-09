{ lib }:
{
  mkFirefoxUserJs = import ./mkFirefoxUserJs.nix { inherit lib; };
  getNormalUsers = import ./getNormalUsers.nix;
}
