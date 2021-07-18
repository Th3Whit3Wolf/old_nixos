{ config, lib, pkgs, ... }:
with lib;
with builtins;
let
  currLang = baseNameOf (builtins.toString ./.);
  polyglot = config.nix-polyglot;
  cfg = polyglot.lang.rust;
  enabled = (elem currLang polyglot.langs || elem "all" polyglot.langs) && polyglot.neovim.enable;
  neovimPlugins = mkOption {
    type = with types; listOf (either package pluginWithConfigType);
    default = with pkgs.vimPlugins; [
      {
        plugin = rust-vim;
        optional = true;
      }
      {
        plugin = vim-crates;
        optional = true;
      }
      {
        plugin = vim-cargo-make;
        optional = true;
      }
      {
        plugin = vim-duckscript;
        optional = true;
      }
    ];
  };

in
{
  config.nix-polyglot.neovim = mkIf enabled { plugins = neovimPlugins; };
}
