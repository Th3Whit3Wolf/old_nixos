{ lib, pkgs, ... }:

let
  lockCommand =
    "${pkgs.swaylock-effects}/bin/swaylock --screenshots --clock --indicator --indicator-radius 100 --indicator-thickness 7 --effect-blur 7x5 --effect-vignette 0.5:0.5 --effect-pixelate 3 --ring-color 5d4d7a --grace 2 --fade-in 0.7";

  sysCheck = pkgs.writeScriptBin "sysCheck" ''
        #!${pkgs.stdenv.shell}
        case $1 in
      up) # deals with uptime less than a minute, where the command `uptime` doesn't work
        time="$(${pkgs.procps}/bin/uptime -p )"
        time="''${time/up }"
        time="''${time/ day,/d}"
        time="''${time/ days,/d}"
        time="''${time/ hours,/h}"
        time="''${time/ minutes/m}"
        echo ''${time:-'less than a minute'}
        ;;
      cpuavg) # avg cpu load since the cpu started
        grep 'cpu ' /proc/stat | awk '{usage=($2+$4)*100/($2+$4+$5)} END {print usage "%"}' ;;
      disk) # disk space of the root partition
        percent_used="$(df -h /persist | tail -n -1 | awk '{ print $4 "\t" }')"
        df -h /persist | tail -n -1 | awk '{ print $4" / "$3 }'
        ;;
      mem) # source: https://github.com/KittyKatt/screenFetch/issues/386#issuecomment-249312716
        while IFS=":" read -r a b; do
              case $a in
                "MemTotal") ((mem_used+=''${b/kB})); mem_total="''${b/kB}" ;;
                "Shmem") ((mem_used+=''${b/kB}))  ;;
                "MemFree" | "Buffers" | "Cached" | "SReclaimable")
                mem_used="$((mem_used-=''${b/kB}))"
              ;;
              esac
        done < /proc/meminfo

            echo "$((mem_used / 1024))kb / $((mem_total / 1024))kb"
        ;;
    esac
  '';
in

{
  def = ''
    <box orientation="v" space-evenly="false" class="sidebar">
        <button onclick="eww close sidebar" class="side-close" hexpand="true"></button>
        <box class="time" orientation="h" space-evenly="false" halign="center">
            <box class="hour">{{hour}}</box>
            <box class="semicolon">:</box>
            <box class="min">{{min}}</box>
            <box class="ampm">{{ampm}}</box>
        </box>
        <box class="date" orientation="h" space-evenly="false" halign="center">{{weekday}}, {{month}} {{day_num}}</box>
        <box class="userinfo" halign="center" space-evenly="false" orientation="h">
            <box halign="center" space-evenly="false" orientation="v">
                <box class="face-img"></box>
                <label class="username" text="{{usernm}}"/>
                <label class="hostname" text="@{{hostnm}}"/>
            </box>
            <box orientation="v" space-evenly="false" valign="center">
                <box class="sysinfo" orientation="h" space-evenly="false">
                    <label class="syslabel" text="  "/>
                    <label class="sysinfo-text" text="{{uptime}}"/>
                    <label text=" uptime"/>
                </box>
                <box class="sysinfo" orientation="h" space-evenly="false">
                    <label class="syslabel" text="  "/>
                    <label class="sysinfo-text" text="{{cpuavg}} "/>
                    <label text="avg"/>
                </box>
                <box class="sysinfo" orientation="h" space-evenly="false">
                    <label class="syslabel" text="﫭  "/>
                    <label class="sysinfo-text" text="{{mem}} "/>
                    <label text="used"/>
                </box>
                <box class="sysinfo" orientation="h" space-evenly="false">
                    <label class="syslabel" text="  "/>
                    <label class="sysinfo-text" text="{{disk}} "/>
                    <label text="free"/>
                </box>
            </box>
        </box>
        <box class="powermenu" space-evenly="true" orientation="h" halign="center">
            <button class="powerbuttons" onclick="lockCommand"></button>
            <button class="powerbuttons" onclick="systemctl suspend">鈴</button>
            <button class="powerbuttons" onclick="swaymsg exit"></button>
            <button class="powerbuttons" onclick="systemctl poweroff">ﳁ</button>
        </box>
    </box>
  '';

  script-vars = {
    day_num = {
      text = ''date "+%d"'';
      interval = {
        quantity = 2;
        units = "h";
      };
    };
    month = {
      text = ''date "+%b"'';
      interval = {
        quantity = 12;
        units = "h";
      };
    };
    weekday = {
      text = ''date "+%a"'';
      interval = {
        quantity = 2;
        units = "h";
      };
    };
    min = {
      text = ''date "+%M"'';
      interval = {
        quantity = 10;
        units = "s";
      };
    };
    hour = {
      text = ''date "+%I"'';
      interval = {
        quantity = 25;
        units = "s";
      };
    };
    ampm = {
      text = ''date "+%P"'';
      interval = {
        quantity = 1;
        units = "h";
      };
    };
    uptime = {
      text = ''bash -c "${sysCheck}/bin/sysCheck up"'';
      interval = {
        quantity = 60;
        units = "s";
      };
    };
    cpuavg = {
      text = ''bash -c "${sysCheck}/bin/sysCheck cpuavg"'';
      interval = {
        quantity = 60;
        units = "s";
      };
    };
    disk = {
      text = ''bash -c "${sysCheck}/bin/sysCheck disk"'';
      interval = {
        quantity = 1;
        units = "h";
      };
    };
    mem = {
      text = ''bash -c "${sysCheck}/bin/sysCheck mem"'';
      interval = {
        quantity = 30;
        units = "s";
      };
    };

  };
  vars = {
    userIMG = "/home/doc/.cache/face.png";
    usernm = "doc";
    hostnm = "tardis";
  };
}
