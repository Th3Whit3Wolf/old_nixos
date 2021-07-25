{ config, options, lib, pkgs, rust-stable, ... }:
with lib;
with builtins;
let
  currLang = baseNameOf (builtins.toString ./.);
  polyglot = config.nix-polyglot;
  cfg = polyglot.lang.${currLang};
  enabled = (elem currLang polyglot.langs || elem "all" polyglot.langs) && polyglot.vscode.enable;
  jsonFormat = pkgs.formats.json { };

  langExtensions = with pkgs.vscode-extensions; [
    serayuzgur.crates
    matklad.rust-analyzer
    belfz.search-crates-io
  ];

  rust-stable = pkgs.rust-bin.stable.latest.default.override {
    extensions =
      [ "cargo" "clippy" "rust-docs" "rust-src" "rust-std" "rustc" "rustfmt" ];
    targets = [
      "x86_64-unknown-linux-gnu"
      "x86_64-unknown-linux-musl"
      "wasm32-unknown-unknown"
      "wasm32-wasi"
    ];
  };

  langSettings = {
    "rust-analyzer.cargo.allFeatures" = true;
    "rust-analyzer.checkOnSave.command" = "clippy";
    "rust-analyzer.procMacro.enable" = true;
    "rust-analyzer.serverPath" = "${pkgs.rust-analyzer}";
    "rust-analyzer.rustcSource" = "${rust-stable}/lib/rustlib/src/rust/library/";
  };
in
{
  options.nix-polyglot.lang.${currLang}.vscode = {
    extensions = mkOption {
      type = types.listOf types.package;
      default = langExtensions;
      example = literalExample "[ pkgs.vscode-extensions.matklad.rust-analyzer ]";
      description = ''
        The extensions Visual Studio Code should use with for programming in ${currLang}.
        These will override but not delete manually installed ones.
      '';
    };
    settings = mkOption {
      type = jsonFormat.type;
      example = literalExample ''
        "rust-analyzer.cargo.allFeatures" = true;
        "rust-analyzer.checkOnSave.command" = "clippy";
        "rust-analyzer.procMacro.enable" = true;
        "rust-analyzer.serverPath" = "${pkgs.rust-analyzer}";
        "rust-analyzer.rustcSource" = "${rust-stable}/lib/rustlib/src/rust/library/";
      '';
      default = langSettings;
      description = ''
        User settings for vscode related to ${currLang}.
      '';
    };
  };
}
