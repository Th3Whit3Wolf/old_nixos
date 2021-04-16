# modules/themes/alucard/default.nix --- a regal dracula-inspired theme

{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.theme;
  static = config.dotfiles.configDir;
in {
  config = mkIf (cfg.active == "spaceLight") (mkMerge [

    # Desktop-agnostic configuration
    {
      user.packages = with pkgs; [ my.spacemacs-theme my.spacemacs-icons ];

      fonts = {
        fonts = with pkgs; [
          fira-code
          fira-code-symbols
          jetbrains-mono
          my.san-francisco-font
          my.san-francisco-mono-font
          nerdfonts
          siji
          font-awesome-ttf
        ];
        fontconfig.defaultFonts = {
          sansSerif = [ "SFNS Display" ];
          monospace = [ "SF Mono" ];
        };
      };

      modules = {
        theme = {
          wallpaper =
	    mkDefault ./config/wallpaper/bg_1.jpg;
	  editor = {
	    vscode = {
	      extension = [ pkgs.vscode-extensions.cometeer.spacemacs ];
	      colorTheme = "Spacemacs - light";
	      fontFamily = "'JetBrainsMono Nerd Font Mono'";
	    };
	  };
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
      };

      home-manager.users.${config.user.name} = {
        programs = {
          alacritty = {
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
                  foreground = "#655370";
                  background = "#fbf8ef";
                };

                # Cursor colors
                cursor = {
                  text = "#100a14";
                  cursor = "#efeae9";
                };

                # Normal colors
                normal = {
                  black = "#d2ceda";
                  red = "#f2241f";
                  green = "#67b11d";
                  yellow = "#b1951d";
                  blue = "#3a81c3";
                  magenta = "#a31db1";
                  cyan = "#21b8c7";
                  white = "#655370";
                };

                # Bright colors
                bright = {
                  black = "#efeae9";
                  red = "#DF201C";
                  green = "#29A0AD";
                  yellow = "#DB742E";
                  blue = "#3980C2";
                  magenta = "#2C9473";
                  cyan = "#6B3062";
                  white = "#a094a2";
                };
              };
            };
          };
          mako = {
            backgroundColor = "#FBF8EF";
            borderColor = "#D3D3E780";
            borderRadius = 12;
            borderSize = 10;
            font = "SFNS Display Bold 13";
	    margin = "25";
	    padding = 0;
            textColor = "#655370";
            extraConfig = ''
              [hidden]
              format=(and %h more)
              text-color=#686868

              [urgency=high]
              background-color=#c00000
              border-color=#ff0000
            '';
          };
        };
        wayland.windowManager.sway.config.colors = {
          focused = {
            background = "#FBF8EF";
            border = "#FBF8EF";
            childBorder = "#FBF8EF";
            indicator = "#5D4D7A";
            text = "#655370";
          };
          focusedInactive = {
            background = "#FBF8EF";
            border = "#FBF8EF";
            childBorder = "#FBF8EF";
            indicator = "#FBF8EF";
            text = "#a094a2";
          };
          unfocused = {
            background = "#FBF8EF";
            border = "#FBF8EF";
            childBorder = "#FBF8EF";
            indicator = "#FBF8EF";
            text = "#b3a7b5";
          };
        };
      };
    }

    # Desktop (X11) theming
    (mkIf config.services.xserver.enable {
      # Compositor
      services.picom = {
        fade = true;
        fadeDelta = 1;
        fadeSteps = [ 1.0e-2 1.2e-2 ];
        shadow = true;
        shadowOffsets = [ (-10) (-10) ];
        shadowOpacity = 0.22;
        # activeOpacity = "1.00";
        # inactiveOpacity = "0.92";
        settings = {
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
