{ lib }:

{ overlay, overlays, pkgs }:
let
  packagesNames = lib.attrNames (overlay null null)
    ++ lib.attrNames (lib.concatAttrs
    (lib.attrValues
      (lib.mapAttrs (_: v: v null null) overlays)
    )
  );
in
lib.fold
  (key: sum: lib.recursiveUpdate sum {
    ${key} = pkgs.${key};
  })
{ }
  packagesNames
