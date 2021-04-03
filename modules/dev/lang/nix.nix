{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let 
  cfg = config.modules.dev.lang.nix;
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
  options.modules.dev.lang.nix = {
    enable = mkBoolOpt false;
    neovimPlugins  = mkOption {
      type = with types; listOf (either package pluginWithConfigType);
      default = [
        { plugin = pkgs.vimPlugins.vim-nix; optional = true;}
      ];
    };
    vscodeExt = mkOption {
      type = types.listOf types.package;
      description = "List of vscode extensions to enable";
      default = (with pkgs.vscode-extensions; [
        jnoortheen.nix-ide
        arrterian.nix-env-selector
      ]);
    };
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [ rnix-lsp nixfmt direnv lorri ];

    services.lorri.enable = true;

    home-manager.users.${config.user.name}.programs.direnv = { enable = true; };
  };
}
