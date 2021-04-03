# modules/desktop/term/st.nix
#
# I like (x)st. This appears to be a controversial opinion; don't tell anyone,
# mkay?

{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.desktop.term.alacritty;

  colorschemes = {
    space-light = {
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
    space-dark = {
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
in {
  options.modules.desktop.term.alacritty = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [ alacritty ];

    home-manager.users.${config.user.name}.programs.alacritty = {
      enable = true;
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
        mouse.hide_when_typing = true;
        # bell.duration = 100;
        colors = colorschemes.space-dark;
      };
    };
  };
}

