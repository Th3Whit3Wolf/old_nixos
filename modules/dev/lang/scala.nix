{ config, options, lib, pkgs, my, ... }:

with lib;
with lib.my;
let 
  cfg = config.modules.dev.lang.scala;
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
  options.modules.dev.lang.scala = {
    enable = mkBoolOpt false;
    neovimPlugins  = mkOption {
      type = with types; listOf (either package pluginWithConfigType);
      default = [
        { plugin = pkgs.vimPlugins.vim-scala;  optional = true;}
      ];
    };
    vscodeExt = mkOption {
      type = types.listOf types.package;
      description = "List of vscode extensions to enable";
      default = (with pkgs.vscode-extensions; [ scalameta.metals ]);
    };
  };

  config = mkIf cfg.enable { user.packages = with pkgs; [ scala jdk sbt ]; };
}
