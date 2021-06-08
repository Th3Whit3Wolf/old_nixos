{ config, lib, pkgs, ... }:

with lib;
with builtins;

let
    cfg = config.nix-polyglot.lang.rust;
    currLang = baseNameOf (builtins.toString ./.);
    enabled = elem currLang config.nix-polyglot.langs;
in 

{
    config = mkIf enabled {

    };
}