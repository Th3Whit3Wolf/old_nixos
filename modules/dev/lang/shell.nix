# modules/dev/shell.nix --- http://zsh.sourceforge.net/
#
# Shell script programmers are strange beasts. Writing programs in a language
# that wasn't intended as a programming language. Alas, it is not for us mere
# mortals to question the will of the ancient ones. If they want shell programs,
# they get shell programs.

{ config, options, lib, pkgs, my, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.dev.lang.shell;
  jsonFormat = pkgs.formats.json { };
in {
  options.modules.dev.lang.shell = {
    enable = mkBoolOpt false;
    vscode = {
      ext = mkOption {
        type = types.listOf types.package;
        description = "List of vscode extensions to enable";
        default = (with pkgs.vscode-extensions; [
          mads-hartmann.bash-ide-vscode
          rogalmic.bash-debug
          Remisa.shellman
          foxundermoon.shell-format
        ]);
      };
      settings = mkOption {
        type = jsonFormat.type;
        description = ''
          Configuration written to Visual Studio Code's
          <filename>settings.json</filename>.
        '';
        default = { "bashIde.highlightParsingErrors" = true; };
      };
    };
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      shellcheck
      nodePackages.bash-language-server
      bashdb
    ];
  };
}
