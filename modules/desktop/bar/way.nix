{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.desktop.bar.way;
  configDir = config.dotfiles.configDir;
  lockCommand = ''
    ${pkgs.swaylock-effects}/bin/swaylock \
      --screenshots \
      --clock \
      --indicator \
      --indicator-radius 100 \
      --indicator-thickness 7 \
      --effect-blur 7x5 \
      --effect-vignette 0.5:0.5 \
      --effect-pixelate 3 \
      --ring-color 5d4d7a \
      --fade-in 0.6
  '';
  #lockCommand = "${pkgs.swaylock-effects}/bin/swaylock -f --effect-greyscale effect-blur 7x7 --effect-pixelate 3 --ring-color 5d4d7a --fade-in 3 -F -S";
  nwgPath = "${configDir}/bar/waybar/nwg-launchers/";
  nwgbarImages =
    "/home/${config.user.name}/.config/nwg-launchers/nwgbar/images/";
  nwgBarJson = [
    {
      name = "Lock screen";
      exec = "${lockCommand}";
      icon = "${nwgbarImages}/lock.svg";
    }

    {
      name = "Suspend";
      exec = "systemctl suspend; ${lockCommand}";
      icon = "${nwgbarImages}/suspend.svg";
    }

    {
      name = "Logout";
      exec = "loginctl terminate-user ${config.user.name}";
      icon = "${nwgbarImages}/logout.svg";
    }

    {
      name = "Reboot";
      exec = "systemctl reboot";
      icon = "${nwgbarImages}/reboot.svg";
    }

    {
      name = "Shutdown";
      exec = "systemctl -i poweroff";
      icon = "${nwgbarImages}/shutdown.svg";

    }
  ];
in {
  options.modules.desktop.bar.way = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    home-manager.users.${config.user.name}.programs.waybar.enable = true;

    user.packages = with pkgs; [ nwg-launchers ];

    # link recursively so other modules can link files in their folders
    home.configFile = {
      "waybar/config" = {
        text = lib.generators.toJSON { } {
          "layer" = "bottom";
          "position" = "top";
          "height" = 21;
          "modules-center" = [ "sway/workspaces" ];
          "modules-right" = [ "tray" "clock" "custom/powermenu" ];
          "modules-left" = [
            "custom/start"
            "battery#bat0"
            "temperature"
            "pulseaudio"
            "memory"
            "cpu"
          ];
          "sway/mode" = { format = ''<span style="italic">{}</span>''; };
          "sway/workspaces" = { format = "{name}"; };
          "tray" = {
            icon-size = 24;
            spacing = 6;
          };
          "clock" = {
            interval = 10;
            format = "{:<b>%a %d %b|%H:%M</b>}";
            tooltip-format = ''
              <big><b>{:%Y %B}</b></big>
              <span font_desc='Hack 10'>{calendar}</span>'';
            format-alt = "{:%Y-%m-%d}";
          };
          "temperature" = {
            critical-threshold = 80;
            format = "{icon} {temperatureC}°";
            format-icons = [ "" "" "" "" "" ];
          };
          "battery#bat0" = {
            bat = "BATT";
            states = {
              warning = 30;
              critical = 15;
            };
            interval = 30;
            format = "{icon} {capacity}%";
            format-charging = "{capacity}% ";
            format-plugged = "";
            format-alt = "{time} {icon}";
            format-icons = [ "" "" "" "" "" "" "" "" "" "" "" ];
          };
          "pulseaudio" = {
            format = "{icon} {volume}%";
            format-bluetooth = "{icon} {volume} ";
            format-bluetooth-muted = "{icon}  ";
            format-muted = "";
            format-source = "";
            format-source-muted = "";
            format-icons = {
              headphone = "";
              hands-free = "";
              headset = "";
              phone = "";
              portable = "";
              car = "";
              default = [ "" "" "" ];
            };
            on-click = "pavucontrol";
          };
          "cpu" = {
            format = " {}%";
            tooltip = true;
            interval = 2;
            on-click =
              "${pkgs.alacritty}/bin/alacritty -e ${pkgs.unstable.bottom}/bin/btm";
          };
          "memory" = {
            format = " {used:0.2f}GB / {total:0.0f}GB";
            interval = 2;
            max-length = 16;
            on-click =
              "${pkgs.alacritty}/bin/alacritty -e ${pkgs.unstable.bottom}/bin/btm";
          };
          "custom/kblayout" = {
            format = " <b>{}</b>";
            exec = "sway-kbd-indicator";
            tooltip = false;
          };
          "custom/start" = {
            format = "<big></big>";
            on-click = "${pkgs.nwg-launchers}/bin/nwggrid";
            tooltip = false;
          };
          "custom/powermenu" = {
            format = "<big></big>";
            on-click = "${pkgs.nwg-launchers}/bin/nwgbar";
            tooltip = false;
          };
          "custom/cpu" = {
            format = " <span background='#686868'>{}</span>";
            return-type = "json";
            exec = "sleep 1 && cpu_bar";
            tooltip = false;
            on-click = "${pkgs.unstable.bottom}";
          };
          "custom/memory" = {
            format = " <span background='#686868'>{}</span>";
            exec = "mem_bar";
            tooltip = false;
          };
        };
      };
      "waybar/style.css" = { source = "${configDir}/bar/waybar/style.css"; };
      "nwg-launchers/nwgbar/bar.json" = { text = builtins.toJSON nwgBarJson; };
      "nwg-launchers/nwgbar/images" = {
        source = "${nwgPath}/nwgbar/images";
        recursive = true;
      };
      "nwg-launchers/nwgbar/style.css" = {
        source = "${nwgPath}/nwgbar/style.css";
      };
      "nwg-launchers/nwggrid/style.css" = {
        source = "${nwgPath}/nwggrid/style.css";
      };

    };
  };
}
