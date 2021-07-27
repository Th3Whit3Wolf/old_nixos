{ pkgs, lib, ... }:
let
  folder = ./.;
  toImport = name: value: folder + ("/" + name);
  filterCaches = key: value: value == "directory";
  imports = lib.mapAttrsToList toImport
    (lib.filterAttrs filterCaches (builtins.readDir folder));
in
{

  #inherit imports;
  imports = [
    ./rust
  ];
}
