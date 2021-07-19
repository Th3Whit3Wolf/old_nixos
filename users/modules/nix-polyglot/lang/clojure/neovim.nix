{ config, lib, pkgs, ... }:
with lib;
with builtins;
let
  currLang = baseNameOf (builtins.toString ./.);
  polyglot = config.nix-polyglot;
  cfg = polyglot.lang.${currLang};
  enabled = (elem currLang polyglot.langs || elem "all" polyglot.langs) && polyglot.neovim.enable;

  plugins = mkOption {
    type = with types; listOf (either package pluginWithConfigType);
    default = with pkgs.vimPlugins; [
      {
        plugin = vim-clojure-static;
        optional = true;
      }
      {
        plugin = vim-clojure-highlight;
        optional = true;
      }
      {
        plugin = vim-fireplace;
        optional = true;
      }
      {
        plugin = conjure;
        optional = true;
      }
      {
        plugin = vimPlugins-ron-vim;
        optional = true;
      }
    ];
  };
in
{
  options.nix-polyglot.lang.${currLang}.neovim = {
    plugins = mkOption {
      type = with types; listOf (either package pluginWithConfigType);
      default = [ ];
      example = literalExample ''
        with pkgs.vimPlugins; [
            yankring
            vim-nix
            { plugin = vim-startify;
            config = "let g:startify_change_to_vcs_root = 0";
            }
        ]
      '';
      description = ''
        List of neovim plugins to be used for ${currLang} programming.
      '';
    };
  };
}
