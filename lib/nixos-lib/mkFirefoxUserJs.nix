{ lib, ... }:
{ firefoxConfig ? { } }:
let
  inherit (lib) concatStrings mapAttrsToList;
  inherit (builtins) toJSON;
in
''
  ${concatStrings (mapAttrsToList
    (name: value: ''
  user_pref("${name}", ${toJSON value});
    '')
  firefoxConfig)}
''
