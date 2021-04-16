{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.desktop.bar.way;
  configDir = config.dotfiles.configDir;
  
in {
  options.modules.desktop.bar.way = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    home-manager.users.${config.user.name}.programs.waybar.enable = true;
    user.packages = with pkgs; [ nwg-launchers ];
  };
}
