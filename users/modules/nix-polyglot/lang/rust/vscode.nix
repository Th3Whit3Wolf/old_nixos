{ config, options, lib, pkgs, ... }:
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

  langSettings = {
    rust-analyzer = {
      cargo.allFeatures = true;
      checkOnSave.command = "clippy";
      procMacro.enable = true;
      #rustcSource = "${pkgs.rust-analyzer}";
    };
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
        langSettings = {
          rust-analyzer = {
            cargo.allFeatures = true;
            checkOnSave.command = "clippy";
            procMacro.enable = true;
          };
        };
      '';
      default = (toJSON langSettings);
      description = ''
        User settings for vscode related to ${currLang}.
      '';
    };
  };
}