{ config, lib, pkgs, ... }:

let
  inherit (config.home) homeDirectory username;
  pactl = "${pkgs.pulseaudioFull}/bin/pactl";
  brightnessctl = "${pkgs.brightnessctl}/bin/brightnessctl";
  lockCommand =
    "${pkgs.swaylock-effects}/bin/swaylock --screenshots --clock --indicator --indicator-radius 100 --indicator-thickness 7 --effect-blur 7x5 --effect-vignette 0.5:0.5 --effect-pixelate 3 --ring-color 5d4d7a --grace 2 --fade-in 0.7";
  dsq = "''";
  notificationUpdater = pkgs.writeScriptBin "notificationUpdater" ''
    #!${pkgs.stdenv.shell}

    LINE=0
    COUNT=0
    LITERAL='<box orientation="v" spacing="10" space-evenly="false" style="margin: 10px 5px 5px 5px;padding: 0px">'

    show() {
      ((COUNT+=1))
      killall -q sleep 2> /dev/null
      ${pkgs.eww}/bin/eww update notificationBool=true
      ${pkgs.eww}/bin/eww update notificationsContent="$LITERAL"
    }

    hide() {
      sleep 4.5 && ${pkgs.eww}/bin/eww update notification=false
    }

    reset() {
      LITERAL='<box orientation="v" spacing="10" space-evenly="false" style="margin: 10px 5px 5px 5px;padding: 0px">'
      COUNT=0
    }

    build() {
      if [[ $BODY =~ .{50,} ]]; then
        BODY="${BODY:0:50}..."
      fi
      if [[ $SUMMARY =~ .{30,} ]]; then
        SUMMARY="${SUMMARY:0:30}..."
      fi
      if [[ ! -e $APP_ICON && -e ${pkgs.spacemacs-theme}/share/icons/Space-Dark/mimetypes/48/$APP_ICON.svg  ]]; then
        APP_ICON=${pkgs.spacemacs-theme}/share/icons/Space-Dark/mimetypes/48/$APP_ICON.svg
        SHOW_ICON=true
      elif [[ -e $APP_ICON ]]; then
        SHOW_ICON=true
      else
        SHOW_ICON=false
      fi
      if [[ $COUNT -gt 4 ]]; then
        reset
      fi
      LITERAL=''${LITERAL/%'</box>'}
      read -r -d ${dsq} NEW << EOM
      <box orientation="v" space-evenly="false">
        <button onclick="$ACTION">
          <box height="80" spacing="0" orientation="h" space-evenly="false" class="notif">
          <box width="80" halign="center" visible="$SHOW_ICON"
          style="background-image: url('$APP_ICON'); border-radius: 5px 0px 0px 5px; background-size:contain; background-position: center; background-repeat: no-repeat"></box>
            <box width="200" style="margin-left: 15px" valign="center" space-evenly="false" spacing="5" orientation="v" halign="fill" class="content">
              <box width="230" spacing="5" orientation="v" valign="center" halign="start" space-evenly="false">
                <label halign="start" style="color: #dcbb8c; font-size: 14px; font-weight: bold" limit-width="30" markup="$SUMMARY"></label>
                <label halign="start"  style="color: #6f6f6f"
                text="$APP_NAME" limit-width="15"></label>
              </box>
              <label halign="start" valign="center" style="color: #dcbb8c; margin: 0px; padding: 0px" markup="$BODY"></label>
            </box>
          </box>
        </button>
      </box>
    </box>
    EOM
      LITERAL+=$NEW
      show
      hide &
    }

    ${pkgs.tiramisu}/bin/tiramisu -s | while read -r value
    do
      if [[ $value =~ \#.* ]]; then
        :
      else
        case $LINE in
          0 )
            if [[ -z $(${pkgs.eww}/bin/eww state | grep notificationsContent | awk '{printf $2}') ]]; then
              reset
            fi
            APP_NAME="''${value//\"}"
            ;;
          1 )
            APP_ICON="$value"
            ;;
          3 )
            SUMMARY="''${value//\"}"
            ;;
          4 )
            BODY="''${value//\"}"
            ;;
          5 )
            ACTION="$value"
            ;;
          8 )
            LINE=-1
            build
            ;;
        esac
      fi
      ((LINE+=1))
    done
  '';
in
{
  home.packages = with pkgs; [
    alacritty
    #brightnessctl
    wofi
    kanshi
    swaylock-effects
    swayidle
    grim
    sway-contrib.grimshot
    imv
    slurp
    qt5.qtwayland
    nwg-launchers
    wl-clipboard
    mpv
  ];

  systemd.user.sessionVariables = {
    # Wayland Settings
    _JAVA_AWT_WM_NONREPARENTING = "1";
    XDG_SESSION_TYPE = "wayland";
    QT_QPA_PLATFORM = "wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    MOZ_ENABLE_WAYLAND = "1";
  };

  programs.mako = {
    enable = true;
    anchor = "top-center";
    defaultTimeout = 5000;
  };

  wayland.windowManager.sway = {
    enable = true;
    xwayland = true;
    #systemdIntegration = false;
    wrapperFeatures = { gtk = true; };
    extraSessionCommands = "systemctl --user import-environment";
    config = rec {
      bars = lib.mkIf config.programs.waybar.enable [{
        command = "${pkgs.waybar}/bin/waybar";
      }];
      output = {
        eDP-1 = {
          bg =
            if (config.home.theme.wallpaper != null) then
              "${config.home.theme.wallpaper} fill"
            else
              "${homeDirectory}/Pics/wallpaper/flower_dark.jpg fill";
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
        "${modifier}+space" = "exec ${menu} -s $XDG_CONFIG_HOME/wofi/style.css";
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
        "--locked XF86MonBrightnessDown" = "exec ${brightnessctl} set 5%-";
        "--locked XF86MonBrightnessUp" = "exec ${brightnessctl} set +5%";
        "XF86AudioMute" = "exec ${pactl} set-sink-mute @DEFAULT_SINK@ toggle";
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
      fonts = {
        names = [ "SFNS Display Regular" "SpaceMono Nerd Font Mono Regular" ];
        style = "Regular";
        size = 13.0;
      };
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
        #{
        #  command =
        #    "${pkgs.my.persway}/bin/persway -w -a -e '[tiling] opacity 1' -f '[tiling] opacity 0.95; opacity 1'";
        #}
        { command = "${pkgs.kanshi}/bin/kanshi >/tmp/kanshi.log 2>&1"; }
        { command = "systemd-notify --ready"; }
        {
          command =
            "${pkgs.swayidle}/bin/sway/idle -w -d timeout 300 '${lockCommand}' timeout 600 '${pkgs.sway}/bin/swaymsg \"output * dpms off\"' resume '${pkgs.sway}/bin/swaymsg \"output * dpms on\"' before-sleep '${lockCommand}'";
        }
        # Update notifications
        { command = ''bash -c "${notificationUpdater}/bin/notificationUpdater"''; }
        # Build .zcompdump on startup
        { command = "${pkgs.zsh}/bin/zsh -i -c exit"; }
        #{ command = ''if [[ "$(date +%Y" == "1970" ]]; then systemctl restart chronyd fi''; }
      ];
    };
    extraConfig = ''
      default_border pixel 1
      seat seat0 xcursor_theme breeze_cursors 24
      mouse_warping container
      workspace number 1
    '';
  };
}
