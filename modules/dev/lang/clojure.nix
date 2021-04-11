# modules/dev/clojure.nix --- https://clojure.org/
#
# I don't use clojure. Perhaps one day...

{ config, options, lib, pkgs, my, ... }:

with lib;
with lib.my;
let 
  cfg = config.modules.dev.lang.clojure;
  pluginWithConfigType = types.submodule {
    options = {
      config = mkOption {
        type = types.lines;
        description = "vimscript for this plugin to be placed in init.vim";
        default = "";
      };

      optional = mkEnableOption "optional" // {
        description = "Don't load by default (load with :packadd)";
      };

      plugin = mkOption {
        type = types.package;
        description = "vim plugin";
      };
    };
  };
in {
  options.modules.dev.lang.clojure = {
    enable = mkBoolOpt false;
    neovimPlugins  = mkOption {
      type = with types; listOf (either package pluginWithConfigType);
      default = [
        { plugin = pkgs.vimPlugins.vim-clojure-static;    optional = true;}
        { plugin = pkgs.vimPlugins.vim-clojure-highlight; optional = true;}
        { plugin = pkgs.vimPlugins.vim-fireplace;         optional = true;}
        { plugin = pkgs.vimPlugins.conjure;               optional = true;}
	# eraserhd/parinfer-rust
      ];
    };
    vscodeExt = mkOption {
      type = types.listOf types.package;
      description = "List of vscode extensions to enable";
      default = (with pkgs.vscode-extensions; [ betterthantomorrow.calva ]);
    };
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      clojure
      clojure-lsp
      parinfer-rust
      lumo
      joker
      leiningen
    ];
  };
}
