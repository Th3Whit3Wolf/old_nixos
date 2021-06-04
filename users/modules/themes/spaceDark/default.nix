{ config, lib, pkgs, ... }:
with lib;

let
  cfp = config.programs;
in
{
  config = mkIf (config.home.theme == "Space Dark")
    (mkMerge [

      (mkIf cfp.bat.enable
        {
          programs.bat.themes = "TwoDark";
        })
      (mkIf cfp.mako.enable
        {
          programs.mako = {
            backgroundColor = "#292b2e";
            borderColor = "#5d4d7a";
            borderRadius = 12;
            borderSize = 6;
            font = "SFNS Display Bold 13";
            padding = "6";
            margin = "25";
            textColor = "#b2b2b2";
            extraConfig = ''
              [hidden]
              format=(and %h more)
              text-color=#686868
              [urgency=high]
              background-color=#c00000
              border-color=#ff0000
            '';

          };
        })

    ]);
}
