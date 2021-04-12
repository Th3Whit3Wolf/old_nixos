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

    environment = {
      etc."greetd/environments".text = ''
river
sway
zsh
      '';
      etc."greetd/sway".text = ''
	# `-l` activates layer-shell mode. Notice that `swaymsg exit` will run after gtkgreet.
	exec "${pkgs.greetd.gtkgreet}/bin/gtkgreet -l; ${pkgs.sway}/bin/swaymsg exit"

	bindsym Mod4+shift+e exec swaynag \
	  -t warning \
	  -m 'What do you want to do?' \
	  -b 'Poweroff' 'systemctl poweroff' \
	  -b 'Reboot' 'systemctl reboot'

       include /etc/sway/config.d/*
      '';
      etc."greetd/gtkgreet.css".text = ''
	window {
   background-image: url("file:///persist/home/doc/Pics/wallpaper/kurzgesagt/1886920.png");
   background-size: cover;
   background-position: center;
}

box#body {
   background-color: rgba(50, 50, 50, 0.5);
   border-radius: 10px;
   padding: 50px;
	}
	'';
      sessionVariables = {
        _JAVA_AWT_WM_NONREPARENTING = "1";
        XDG_SESSION_TYPE = "wayland";
        QT_QPA_PLATFORM = "wayland";
	QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
      };
    };
    programs.sway.enable = true;
    user.extraGroups = [ "video" ];
    user.packages = with pkgs; [
      my.eww
      my.river
      my.kile
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
	    command = "${pkgs.sway}/bin/sway --config /etc/greetd/sway";
	  };
	  initial_session = {
	    user = config.user.name;
	    command = "{pkgs.sway}/bin/sway}";
	  };
	};
      };
    }; 

    home.configFile."river/init".text = '';
#!/bin/sh

# This is the example configuration file for river(1).
#
# If you wish to edit this, you will probably want to copy it to
# $XDG_CONFIG_HOME/river/init or $HOME/.config/river/init first.
#
# See the riverctl(1) man page for complete documentation

# Use the "logo" key as the primary modifier
mod="Mod4"

# Mod+Return to start an instance of alacritty
riverctl map normal $mod+Shift Return spawn ${pkgs.alacritty}/bin/alacritty

# Mod+W to start firefox
riverctl map normal $mod w spawn ${pkgs.firefox-wayland}/bin/firefox

# Mod+Q to close the focused view
riverctl map normal $mod Q close

# Mod+E to exit river
riverctl map normal $mod E exit

# Mod+J and Mod+K to focus the next/previous view in the layout stack
riverctl map normal $mod J focus-view next
riverctl map normal $mod K focus-view previous

# Mod+Shift+J and Mod+Shift+K to swap the focused view with the next/previous
# view in the layout stack
riverctl map normal $mod+Shift J swap next
riverctl map normal $mod+Shift K swap previous

# Mod+Period and Mod+Comma to focus the next/previous output
riverctl map normal $mod Period focus-output next
riverctl map normal $mod Comma focus-output previous

# Mod+Shift+{Period,Comma} to send the focused view to the next/previous output
riverctl map normal $mod+Shift Period send-to-output next
riverctl map normal $mod+Shift Comma send-to-output previous

# Mod+Return to bump the focused view to the top of the layout stack
riverctl map normal $mod Return zoom

# Mod+H and Mod+L to decrease/increase the main factor by 5%
# If using rivertile(1) this determines the width of the main stack.
riverctl map normal $mod H mod-main-factor -0.05
riverctl map normal $mod L mod-main-factor +0.05

# Mod+Shift+H and Mod+Shift+L to increment/decrement the number of
# main views in the layout
riverctl map normal $mod+Shift H mod-main-count +1
riverctl map normal $mod+Shift L mod-main-count -1

# Mod+Alt+{H,J,K,L} to move views
riverctl map normal $mod+Mod1 H move left 100
riverctl map normal $mod+Mod1 J move down 100
riverctl map normal $mod+Mod1 K move up 100
riverctl map normal $mod+Mod1 L move right 100

# Mod+Alt+Control+{H,J,K,L} to snap views to screen edges
riverctl map normal $mod+Mod1+Control H snap left
riverctl map normal $mod+Mod1+Control J snap down
riverctl map normal $mod+Mod1+Control K snap up
riverctl map normal $mod+Mod1+Control L snap right

# Mod+Alt+Shif+{H,J,K,L} to resize views
riverctl map normal $mod+Mod1+Shift H resize horizontal -100
riverctl map normal $mod+Mod1+Shift J resize vertical 100
riverctl map normal $mod+Mod1+Shift K resize vertical -100
riverctl map normal $mod+Mod1+Shift L resize horizontal 100

# Mod + Left Mouse Button to move views
riverctl map-pointer normal $mod BTN_LEFT move-view

# Mod + Right Mouse Button to resize views
riverctl map-pointer normal $mod BTN_RIGHT resize-view

for i in $(seq 1 9)
do
    tags=$((1 << ($i - 1)))

    # Mod+[1-9] to focus tag [0-8]
    riverctl map normal $mod $i set-focused-tags $tags

    # Mod+Shift+[1-9] to tag focused view with tag [0-8]
    riverctl map normal $mod+Shift $i set-view-tags $tags

    # Mod+Ctrl+[1-9] to toggle focus of tag [0-8]
    riverctl map normal $mod+Control $i toggle-focused-tags $tags

    # Mod+Shift+Ctrl+[1-9] to toggle tag [0-8] of focused view
    riverctl map normal $mod+Shift+Control $i toggle-view-tags $tags
done

# Mod+0 to focus all tags
# Mod+Shift+0 to tag focused view with all tags
all_tags=$(((1 << 32) - 1))
riverctl map normal $mod 0 set-focused-tags $all_tags
riverctl map normal $mod+Shift 0 set-view-tags $all_tags

# Mod+Space to toggle float
riverctl map normal $mod Space toggle-float

# Mod+F to toggle fullscreen
riverctl map normal $mod F toggle-fullscreen

# Mod+{Up,Right,Down,Left} to change layout orientation
riverctl map normal $mod Up layout rivertile top
riverctl map normal $mod Right layout rivertile right
riverctl map normal $mod Down layout rivertile bottom
riverctl map normal $mod Left layout rivertile left

# Mod+S to change to Full layout
riverctl map normal $mod S layout full

# Declare a passthrough mode. This mode has only a single mapping to return to
# normal mode. This makes it useful for testing a nested wayland compositor
riverctl declare-mode passthrough

# Mod+F11 to enter passthrough mode
riverctl map normal $mod F11 enter-mode passthrough

# Mod+F11 to return to normal mode
riverctl map passthrough $mod F11 enter-mode normal

# Various media key mapping examples for both normal and locked mode which do
# not have a modifier
for mode in normal locked
do
    # Eject the optical drive
    riverctl map $mode None XF86Eject spawn eject -T

    # Control pulse audio volume with pamixer (https://github.com/cdemoulins/pamixer)
    riverctl map $mode None XF86AudioRaiseVolume  spawn pamixer -i 5
    riverctl map $mode None XF86AudioLowerVolume  spawn pamixer -d 5
    riverctl map $mode None XF86AudioMute         spawn pamixer --toggle-mute

    # Control MPRIS aware media players with playerctl (https://github.com/altdesktop/playerctl)
    riverctl map $mode None XF86AudioMedia spawn playerctl play-pause
    riverctl map $mode None XF86AudioPlay  spawn playerctl play-pause
    riverctl map $mode None XF86AudioPrev  spawn playerctl previous
    riverctl map $mode None XF86AudioNext  spawn playerctl next

    # Control screen backlight brighness with light (https://github.com/haikarainen/light)
    riverctl map $mode None XF86MonBrightnessUp   spawn light -A 5
    riverctl map $mode None XF86MonBrightnessDown spawn light -U 5
done

# Set repeat rate
riverctl set-repeat 50 300

# Set the layout on startup
riverctl layout rivertile left

# Set app-ids of views which should float
riverctl float-filter-add "float"
riverctl float-filter-add "popup"
    '';

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
