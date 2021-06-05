{ config, lib, pkgs, ... }:
with lib;

let
  cfp = config.programs;
  cfs = config.services;
  cfg = home.theme;
in
{
  config = mkIf (config.home.theme.name == "Space Dark")
    (mkMerge [
      {
        cfg = {
          wallpaper = ./static/wallpaper.jpg;
          vt = {
            red = "0x29,0xaf,0x00,0xd7,0x87,0x87,0x0d,0xb2,0x29,0xf2,0x23,0xff,0x1a,0xd7,0x14,0xf";
            grn = "0x2b,0x87,0x99,0xaf,0xaf,0x5f,0xcd,0xb2,0x2b,0x20,0xfd,0xfd,0x8f,0x5f,0xff,0xff";
            blu = "0x2e,0xd7,0x66,0x5f,0xff,0xaf,0xcd,0xb2,0x2e,0x1f,0x00,0x00,0xff,0xd7,0xff,0xff";
          };
          requiredPackages = [
            pkgs.spacemacs-theme
            pkgs.breeze-qt5 # For them sweet breeze cursors
          ];
          gtk = {
            theme = "Space-Dark";
            iconTheme = "Space-Dark";
            cursor = {
              name = "breeze_cursors";
              size = 24;
            };
            font = {
              name = "SFNS Display Regular";
              size = 12;
            };
          };
        };
        xdg.configFile = {
          "bottom/bottom.toml" = {
            source = ./static/config/term/bottom/bottom.toml;
          };
          "gitui" = {
            source = ./static/config/term/gitui;
            recursive = true;
          };
          "procs/config.toml" = {
            source = ./static/config/term/procs/config.toml;
          };
          "wofi" = {
            source = ./static/config/term/wofi;
            recursive = true;
          };
        };
        gtk = {
          enable = true;
          theme.name = cfg.gtk.theme;
          iconTheme.name = cfg.gtk.iconTheme;
          font = {
            name = cfg.gtk.font.name;
            size = cfg.gtk.font.size;
          };
          gtk3.extraConfig = {
            gtk-cursor-theme-name = cfg.gtk.cursor.name;
            gtk-cursor-theme-size = cfg.gtk.cursor.size;
            gtk-xft-hinting = 1;
            gtk-xft-hintstyle = "hintfull";
            gtk-xft-rgba = "none";
          };
        };
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
      (mkIf cfp.waybar.enable
        {
          xdg.configFile = {
            "waybar" = {
              source = ./config/waybar;
              recursive = true;
            };
            "nwg-launchers" = {
              source = ./config/nwg-launchers;
              recursive = true;
            };
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

      (mkIf cfs.picom.enable
        {
          services.picom = {
            fade = true;
            fadeDelta = 1;
            fadeSteps = [ 1.0e-2 1.2e-2 ];
            shadow = true;
            shadowOffsets = [ (-10) (-10) ];
            shadowOpacity = 0.22;
            # activeOpacity = "1.00";
            # inactiveOpacity = "0.92";
            extraOptions = {
              shadow-radius = 12;
              # blur-background = true;
              # blur-background-frame = true;
              # blur-background-fixed = true;
              blur-kern = "7x7box";
              blur-strength = 320;
            };
          };
        })
    ]);
}
