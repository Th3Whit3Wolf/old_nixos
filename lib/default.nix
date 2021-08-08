{ lib }:
lib.makeExtensible (self: rec {
  nixos-lib = import ./nixos-lib { inherit lib; };

  inherit (nixos-lib)
    mkFirefoxUserJs
    ;

})
