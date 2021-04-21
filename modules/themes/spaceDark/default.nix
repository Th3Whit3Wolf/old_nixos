# modules/themes/alucard/default.nix --- a regal dracula-inspired theme

{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.theme;
  static = config.dotfiles.configDir;
in {
  config = mkIf (cfg.active == "spaceDark") (mkMerge [

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
          wallpaper = mkDefault ./config/wallpaper/bg_1.jpg;
          editor = {
            vscode = {
              extension = [ pkgs.vscode-extensions.cometeer.spacemacs ];
              colorTheme = "Spacemacs - dark";
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
	  vt = {
	    red = "0x29,0xaf,0x00,0xd7,0x87,0x87,0x0d,0xb2,0x29,0xf2,0x23,0xff,0x1a,0xd7,0x14,0xf";
	    grn = "0x2b,0x87,0x99,0xaf,0xaf,0x5f,0xcd,0xb2,0x2b,0x20,0xfd,0xfd,0x8f,0x5f,0xff,0xff";
	    blu = "0x2e,0xd7,0x66,0x5f,0xff,0xaf,0xcd,0xb2,0x2e,0x1f,0x00,0x00,0xff,0xd7,0xff,0xff";
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
	  bat = {
	    enable = true;
	    config = { theme = "TwoDark"; };
	  };
          mako = {
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
        };
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
      };
      home.configFile = {
	"bottom/bottom.toml" = {
	  source = ./config/term/bottom/bottom.toml;
	};
	"wofi" = {
	  source = ./config/term/wofi;
	  recursive = true;
	};
	"gitui" = {
	  source = ./config/term/gitui;
	  recursive = true;
	};
	"procs/config.toml" = { 
	  source = ./config/term/procs/config.toml;
	};
      };
    }

    (mkIf config.modules.desktop.bar.way.enable {
      home.configFile = {
        "waybar" = {
          source = ./config/waybar;
          recursive = true;
        };
        "nwg-launchers" = {
          source = ./config/nwg-launchers;
          recursive = true;
        };
        "eww" = {
          source = ./config/eww;
          recursive = true;
        };
      };
    })

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
