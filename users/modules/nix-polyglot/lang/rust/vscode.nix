{ config, lib, pkgs, ... }:
with lib;
with builtins;
let
  currLang = baseNameOf (builtins.toString ./.);
  polyglot = config.nix-polyglot;
  cfg = polyglot.lang.rust;
  enabled = (elem currLang polyglot.langs || elem "all" polyglot.langs) && polyglot.vscode.enable;

  vscodeExtensions = with pkgs.vscode-extensions; [
    serayuzgur.crates
    matklad.rust-analyzer
    belfz.search-crates-io
  ];

  vscodeSettings = {
    rust-analyzer = {
      cargo.allFeatures = true;
      checkOnSave.command = "clippy";
      procMacro.enable = true;
      rustcSource = "${pkgs.rust-analyzer}";
    };
  };
in
{
  config.nix-polyglot.vscode = mkIf enabled {
    #userSettings = vscodeSettings;
    extensions = vscodeExtensions;
  };
}
