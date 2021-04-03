# modules/dev/lua.nix --- https://www.lua.org/
#
# I use lua for modding, awesomewm or Love2D for rapid gamedev prototyping (when
# godot is overkill and I have the luxury of avoiding JS). I write my Love games
# in moonscript to get around lua's idiosynchrosies. That said, I install love2d
# on a per-project basis.

{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.dev.lang.lua;
in {
  options.modules.dev.lang.lua = {
    enable = mkBoolOpt false;
    vscodeExt = mkOption {
      type = types.listOf types.package;
      description = "List of vscode extensions to enable";
      default = (with pkgs.vscode-extensions; [ sumneko.lua ]);
    };
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [ lua luaPackages.moonscript ];
  };
}
