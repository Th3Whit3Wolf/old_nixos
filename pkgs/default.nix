/*
  {libs, ...}:

  let 
  toImport = name: value: folder + ("/" + name);
  src = (import ./_sources/generated.nix);
  filterCaches = key: value: value == "directory" && key != "_sources" && key != "bud" && elem key ;
  packageInPath = lib.mapAttrsToList toImport
  (lib.filterAttrs filterCaches (builtins.readDir ./.));
  srcPackages = mapAttrsToList (n: v: n ) src;
  forEach

  in
*/

final: prev: {
  # keep sources this first
  sources = prev.callPackage (import ./_sources/generated.nix) { };
  # then, call packages with `final.callPackage`
  spacemacs-theme = final.callPackage ./spacemacs-theme { };
  sanFrancisco-font = final.callPackage ./sanFrancisco-font { };
  sanFranciscoMono-font = final.callPackage ./sanFranciscoMono-font { };
}

/*
  rec {
  mapPackages = f: with builtins;listToAttrs (map (name: { inherit name; value = f name; }) (filter (v: v != null) (attrValues (mapAttrs (k: v: if v == "directory" && k != "_sources" && K != "bud" then k else null) (readDir ./.)))));
  packages = pkgs: mapPackages (name: pkgs.${name});
  overlay = final: prev: mapPackages (name:
  let
  sources = (import ./_sources/generated.nix) { inherit (final) fetchurl fetchgit; };
  package = import (./. + "/${name}");
  args = builtins.intersectAttrs (builtins.functionArgs package) { source = sources.${name}; };
  in
  final.callPackage package args
  );
  }

*/
