{ config, lib, pkgs, ... }:

let

  inherit (lib) mkDefault mkIf mkOption mkOpt
    types;

in
{
  imports = [ ./spaceDark ];
  options = {
    home.theme = with types; {
      name = mkOption {
        type = with types; nullOr str;
        example = "Space Dark";
        description = ''
          The theme name.
        '';
      };
      wallpaper = mkOption {
        type = with types; nullOr path;
        example = "../Wallpaper/1.jpg";
        description = ''
          The theme wallpaper.
        '';
      };
    };
  };
}
