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

    # Linter
    dbaeumer.vscode-eslint

    # Beautifier
    esbenp.prettier-vscode
    HookyQR.beautify

    # Snipptets
    xabikos.JavaScriptSnippets
    dsznajder.es7-react-js-snippets
    yatki.vscode-surround

    # Frameworks
    octref.vetur
    johnpapa.Angular2
    svelte.svelte-vscode
    msjsdiag.vscode-react-native

    # Imports
    steoates.autoimport
    amatiasq.sort-imports
    wix.vscode-import-cost

    denoland.vscode-deno
    christian-kohler.npm-intellisense
    DominicVonk.parameter-hints
    formulahendry.auto-rename-tag
    vincaslt.highlight-matching-tag
    formulahendry.auto-close-tag
    auchenberg.vscode-browser-preview
    ritwickdey.LiveServer
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
