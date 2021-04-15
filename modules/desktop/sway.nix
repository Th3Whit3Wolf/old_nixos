{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.desktop.sway;
  configDir = config.dotfiles.configDir;
  pactl = "${config.hardware.pulseaudio.package}/bin/pactl";
  bright = "${pkgs.brightnessctl}/bin/brightnessctl";
  lockCommand = "${pkgs.swaylock-effects}/bin/swaylock --screenshots --clock --indicator --indicator-radius 100 --indicator-thickness 7 --effect-blur 7x5 --effect-vignette 0.5:0.5 --effect-pixelate 3 --ring-color 5d4d7a --grace 2 --fade-in 0.7";
  
in {
  options.modules.desktop.sway = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {

    environment.sessionVariables = {
        _JAVA_AWT_WM_NONREPARENTING = "1";
        XDG_SESSION_TYPE = "wayland";
        QT_QPA_PLATFORM = "wayland";
	QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    };
    programs.sway.enable = true;
    user.extraGroups = [ "video" ];
    user.packages = with pkgs; [
      my.eww
      my.kile
      # my.river
      unstable.river
      sway
      unstable.greetd.greetd
      unstable.greetd.gtkgreet
      swaylock-effects
      swayidle
      brightnessctl
      gnome3.adwaita-icon-theme # Icons for gnome packages that sometimes use them but don't depend on them
      gnome3.nautilus
      gnome3.nautilus-python
      gnome3.sushi
      breeze-qt5 # For them sweet cursors
    ];
    services = {
      gvfs.enable = true;
      greetd = {
	enable = true;
	restart = false;
	settings = {
	  default_session = {
	    command = "${pkgs.greetd.tuigreet}/bin/tuigreet --cmd sway";
	    user = "greeter";
	  };
	};
      };
    }; 

    home.configFile = {
      #"river" = {
	#source = "${configDir}/wm/river";
	#recursive = true;
      #};
      "river/init" = {
	text = '' 
#!/bin/sh
mod="Mod4"

riverctl map normal $mod Return spawn alacritty

# Mod+Q to close the focused view
riverctl map normal $mod Q close

# Mod+E to exit river
riverctl map normal $mod E exit
	'';
      };
    };

    home-manager.users.${config.user.name} = {
      gtk = {
        enable = true;
        theme.name = "Space-Dark";
	iconTheme.name = "Space-Dark";
	font.name = "SFNS Display Regular";
	font.size = 12;
	gtk3.extraConfig = {
	  gtk-cursor-theme-name = "breeze_cursors";
	  gtk-cursor-theme-size = 24;
	};
      };
      programs.mako = {
	enable = true;
        anchor = "top-center";
        backgroundColor = "#292b2e";
        borderColor = "#5d4d7a";
        borderRadius = 12;
        borderSize = 10;
        defaultTimeout = 10000;
        extraConfig = ''
          	    [hidden]
                      format=(and %h more)
                      text-color=#686868

                      [urgency=high]
                      background-color=#c00000
                      border-color=#ff0000
          	  '';
        font = "SFNS Display Bold 13";
        margin = "25";
        textColor = "#b2b2b2";
      };
      wayland.windowManager.sway = {
        enable = true;
	xwayland = true;
	wrapperFeatures = {
	  gtk = true;
	};
	extraSessionCommands = "systemctl --user import-environment";
        config = rec {
          bars = [{
            command = mkIf config.modules.desktop.bar.way.enable
              "${pkgs.waybar}/bin/waybar";
          }];
          output = {
            eDP-1 = {
              bg = "${config.user.home}/Pics/wallpaper/flower_dark.jpg fill";
            };
          };
          left = "h";
          right = "l";
          up = "k";
          down = "j";
          menu = "wofi";
          keybindings = {
            # Basics
            "${modifier}+w" = "exec firefox";
            "${modifier}+Return" = "exec ${terminal}";
            "${modifier}+q" = "kill";
            "${modifier}+space" =
              "exec ${menu} -s $XDG_CONFIG_HOME/wofi/style.css";
            "${modifier}+Shift+q" =
              "exec swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -b 'Yes, exit sway' 'swaymsg exit'";
            "${modifier}+Alt+l" = "exec ${lockCommand}";
            # Focus
            "${modifier}+${left}" = "focus left";
            "${modifier}+${down}" = "focus down";
            "${modifier}+${up}" = "focus up";
            "${modifier}+${right}" = "focus right";

            "${modifier}+Left" = "focus left";
            "${modifier}+Down" = "focus down";
            "${modifier}+Up" = "focus up";
            "${modifier}+Right" = "focus right";

            # Moving
            "${modifier}+Shift+${left}" = "move left";
            "${modifier}+Shift+${down}" = "move down";
            "${modifier}+Shift+${up}" = "move up";
            "${modifier}+Shift+${right}" = "move right";

            "${modifier}+Shift+Left" = "move left";
            "${modifier}+Shift+Down" = "move down";
            "${modifier}+Shift+Up" = "move up";
            "${modifier}+Shift+Right" = "move right";

            # Workspaces
            "${modifier}+1" = "workspace number 1";
            "${modifier}+2" = "workspace number 2";
            "${modifier}+3" = "workspace number 3";
            "${modifier}+4" = "workspace number 4";
            "${modifier}+5" = "workspace number 5";
            "${modifier}+6" = "workspace number 6";
            "${modifier}+7" = "workspace number 7";
            "${modifier}+8" = "workspace number 8";
            "${modifier}+9" = "workspace number 9";
            "${modifier}+0" = "workspace number 10";

            "${modifier}+Shift+1" = "move container to workspace number 1";
            "${modifier}+Shift+2" = "move container to workspace number 2";
            "${modifier}+Shift+3" = "move container to workspace number 3";
            "${modifier}+Shift+4" = "move container to workspace number 4";
            "${modifier}+Shift+5" = "move container to workspace number 5";
            "${modifier}+Shift+6" = "move container to workspace number 6";
            "${modifier}+Shift+7" = "move container to workspace number 7";
            "${modifier}+Shift+8" = "move container to workspace number 8";
            "${modifier}+Shift+9" = "move container to workspace number 9";
            "${modifier}+Shift+0" = "move container to workspace number 10";

            # Moving workspaces between outputs
            "${modifier}+Control+${left}" = "move workspace to output left";
            "${modifier}+Control+${down}" = "move workspace to output down";
            "${modifier}+Control+${up}" = "move workspace to output up";
            "${modifier}+Control+${right}" = "move workspace to output right";

            "${modifier}+Control+Left" = "move workspace to output left";
            "${modifier}+Control+Down" = "move workspace to output down";
            "${modifier}+Control+Up" = "move workspace to output up";
            "${modifier}+Control+Right" = "move workspace to output right";

            # Splits
            "${modifier}+b" = "splith";
            "${modifier}+v" = "splitv";

            # Layouts
            "${modifier}+s" = "layout stacking";
            "${modifier}+t" = "layout tabbed";
            "${modifier}+e" = "layout toggle split";
            "${modifier}+f" = "fullscreen toggle";

            "${modifier}+a" = "focus parent";

            "${modifier}+Control+space" = "floating toggle";
            "${modifier}+Shift+space" = "focus mode_toggle";

            # Scratchpad
            "${modifier}+Shift+minus" = "move scratchpad";
            "${modifier}+minus" = "scratchpad show";

            # Resize mode
            "${modifier}+d" = "mode resize";

            # Multimedia Keys
            "--locked XF86MonBrightnessDown" = "exec ${bright} set 5%-";
            "--locked XF86MonBrightnessUp" = "exec ${bright} set +5%";
            "XF86AudioMute" =
              "exec ${pactl} set-sink-mute @DEFAULT_SINK@ toggle";
            "XF86AudioMicMute" =
              "exec ${pactl} set-source-mute @DEFAULT_SOURCE@ toggle";
            "XF86AudioRaiseVolume" =
              "exec ${pactl} set-sink-volume @DEFAULT_SINK@ +5%";
            "XF86AudioLowerVolume" =
              "exec ${pactl} set-sink-volume @DEFAULT_SINK@ -5%";
          };
          input = {
            "type:keyboard" = {
              xkb_layout = "us";
              xkb_variant = "altgr-intl";
              xkb_options = "compose:ralt";
            };
            "type:touchpad" = {
              accel_profile = "adaptive";
              dwt = "enabled";
              tap = "enabled";
              tap_button_map = "lrm";
              drag = "enabled";
              natural_scroll = "enabled";
              middle_emulation = "enabled";
            };
          };
          fonts = [ "SFNS Display Regular" "SpaceMono Nerd Font Mono Regular" ];
          gaps = {
            inner = 12;
            outer = 5;
            smartGaps = true;
            smartBorders = "on";
          };
          terminal = "alacritty";
          focus.followMouse = true;
          focus.forceWrapping = true;
          modifier = "Mod4";
          window = {
            border = 1;
            titlebar = true;
            commands = [
              {
                command = "border pixel 2px";
                criteria = { window_role = "popup"; };
              }
              {
                command = "sticky enable";
                criteria = { floating = ""; };
              }
              {
                command = "floating enable";
                criteria = { app_id = "imv"; };
              }
              {
                command = "floating enable, border none";
                criteria = { app_id = "^launcher$"; };
              }
              {
                command = "floating enable, sticky enable, border none";
                criteria = {
                  app_id = "firefox";
                  title = "Picture-in-Picture";
                };
              }
              {
                command = "floating enable, sticky enable";
                criteria = { class = "mpv"; };
              }
            ];
          };
          startup = [
            {
              command =
                "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
            }
            {
              # Notification deamon:
              command = "${pkgs.mako}/bin/mako >/tmp/mako.log 2>&1";
            }
	    {
	      command =
	        "${pkgs.persway}/bin/persway -w -a -e '[tiling] opacity 1' -f '[tiling] opacity 0.95; opacity 1'";
	    }
            { command = "${pkgs.kanshi}/bin/kanshi >/tmp/kanshi.log 2>&1"; }
	    { command = "systemd-notify --ready"; }
	    { command =
	        "${pkgs.swayidle}/bin/sway/idle -w -d timeout 300 '${lockCommand}' timeout 600 '${pkgs.sway}/bin/swaymsg \"output * dpms off\"' resume '${pkgs.sway}/bin/swaymsg \"output * dpms on\"' before-sleep '${lockCommand}'";
	    }
          ];
        };
        extraConfig = ''
          default_border pixel 1
          seat seat0 xcursor_theme breeze_cursors 24 
          mouse_warping container
          workspace number 1 
        '';
      };
    };
  };
}

