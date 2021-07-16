{pkgs,...}:

{
    #home.packages = [pkgs.nwg-launchers];
    programs.waybar = { 
        enable = true; 
        settings = [
            {
                layer = "bottom";
                position = "top";
                height = 21;
                modules-center = ["sway/workspaces"];
                modules-right =  ["tray" "clock" "custom/powermenu"];
                modules-left = [
                    "custom/start"
                    "battery#bat0"
                    "temperature"
                    "pulseaudio"
                    "memory"
                    "cpu"
                    "custom/kblayout" 
                ];
                modules = {
                #"sway/mode" = {
                 #   format = "<span style=\"italic\">{}</span>";
                #};
                "sway/workspaces" = {
                    format = "{name}";
                };
                "tray" = {
                    icon-size = 24;
                    spacing = 6;
                };
                "clock" = {
                    interval =  10;
                    format = "{:<b>%a %d %b|%H:%M</b>}";
                    tooltip-format = "<big><b>{:%Y %B}</b></big>\n<span font_desc='Hack 10'>{calendar}</span>";
                    format-alt = "{:%Y-%m-%d}";
                };
                "temperature" = {
                    critical-threshold = 80;
                    format = "{icon} {temperatureC}°";
                    format-icons = [ "" "" "" "" ""];
                };
                "battery#bat0" = {
                    bat = "BATT";
                    states = {
                        warning = 30;
                        critical = 15;
                    };
                    interval = 30;
                    format = "{capacity}% {icon}";
                    format-charging = "{capacity}% \uf0e7";
                    format-plugged = "";
                    format-alt = "{time} {icon}";
                    format-icons = ["" "" "" "" ""];
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
                        default = ["" "" ""];
                    };
                    on-click = "pavucontrol";
                };
                "cpu" = {
                    format = " {}%";
                    tooltip = true;
                    interval = 2;
                    on-click = "alacritty -e btm";
                };
                "memory" = {
                    format = " {used:0.2f}GB / {total:0.0f}GB";
                    interval = 2;
                    max-length = 16;
                    on-click = "alacritty -e btm";
                };
                "custom/kblayout" = {
                    format = " <b>{}</b>";
                    exec = "sway-kbd-indicator";
                    tooltip = false;
                };
                "custom/start" = {
                    format = "<big></big>";
                    on-click = "${pkgs.nwg-launchers}/bin/nwgrid";
                    tooltip = false;
                };
                "custom/powermenu" = {
                    format = "<big></big>";
                    on-click = "${pkgs.nwg-launchers}/bin/nwgbar";
                    tooltip = false;
                };
            };
    }
        ];
    }; 
}
