{ config, options, lib, pkgs, ... }:
with lib;
with builtins;
let
  currLang = baseNameOf (builtins.toString ./.);
  polyglot = config.home.nix-polyglot;
  cfg = polyglot.lang.${currLang};
  enabled = (elem currLang polyglot.langs || elem "all" polyglot.langs) && polyglot.vscode.enable;
  jsonFormat = pkgs.formats.json { };

  langExtensions = with pkgs.vscode-extensions; [
    dzhavat.css-initial-value
    ritwickdey.live-sass
    stylelint.vscode-stylelint
    esbenp.prettier-vscode
    Zignd.html-css-class-completion
    mrmlnc.vscode-autoprefixer
    pranaygp.vscode-css-peek
    thekalinga.bootstrap4-vscode
  ];

  langSettings = { };

in
{
  options.home.nix-polyglot.lang.${currLang}.vscode = {
    extensions = mkOption {
      type = types.listOf types.package;
      default = langExtensions;
      description = ''
        The extensions Visual Studio Code should use with for programming in ${currLang}.
      '';
    };
    settings = mkOption {
      type = jsonFormat.type;
      default = langSettings;
      description = ''
        User settings for vscode related to ${currLang}.
      '';
    };
  };
}
