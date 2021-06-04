{ config, lib, pkgs, ... }:
with lib;

let
  cfp = config.programs;
in
{
  config = mkIf (config.home.theme.name == "Space Dark")
    (mkMerge [
      {
        home.theme.wallpaper = ../../../../static/wallpaper/spaceDark-bg.jpg;
      }
      (mkIf cfp.alacritty.enable
        {
          programs.alacritty = {
            settings = {
              font = {
                normal = {
                  family = "JetBrainsMono Nerd Font Mono";
                  style = "Regular";
                };
                bold = {
                  family = "JetBrainsMono Nerd Font Mono";
                  style = "Bold";
                };
                italic = {
                  family = "VictorMono Nerd Font Mono";
                  style = "Italic";
                };
                size = 13.5;
              };
              background_opacity = 0.9;
              colors = {
                # Default colors
                primary = {
                  foreground = "#b2b2b2";
                  background = "#292b2e";
                };

                # Cursor colors
                cursor = {
                  text = "#e3dedd";
                  cursor = "#292b2e";
                };

                # Normal colors
                normal = {
                  black = "#0a0814";
                  red = "#f2241f";
                  green = "#67b11d";
                  yellow = "#b1951d";
                  blue = "#3a81c3";
                  magenta = "#a31db1";
                  cyan = "#21b8c7";
                  white = "#B2B2B2";
                };

                # Bright colors
                bright = {
                  black = "#42444a";
                  red = "#DF201C";
                  green = "#29A0AD";
                  yellow = "#DB742E";
                  blue = "#3980C2";
                  magenta = "#2C9473";
                  cyan = "#6B3062";
                  white = "#686868";
                };
              };
            };
          };
        })

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
      (mkIf config.wayland.windowManager.sway.enable

        {
          wayland.windowManager.sway.config.colors = {
            focused = {
              background = "#292B2E";
              border = "#292B2E";
              childBorder = "#292B2E";
              indicator = "#5D4D7A";
              text = "#B2B2B2";
            };
            focusedInactive = {
              background = "#292B2E";
              border = "#292B2E";
              childBorder = "#292B2E";
              indicator = "#292B2E";
              text = "#686868";
            };
            unfocused = {
              background = "#292B2E";
              border = "#292B2E";
              childBorder = "#292B2E";
              indicator = "#292B2E";
              text = "#555555";
            };
          };

        })

    ]);
}
