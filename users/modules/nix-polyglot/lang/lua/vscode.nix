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
    sumneko.lua
  ];

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
      default = (toJSON { });
      description = ''
        User settings for vscode related to ${currLang}.
      '';
    };
  };
}