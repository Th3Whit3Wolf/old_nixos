{ lib, pkgs, ... }:

let
  lockCommand =
    "${pkgs.swaylock-effects}/bin/swaylock --screenshots --clock --indicator --indicator-radius 100 --indicator-thickness 7 --effect-blur 7x5 --effect-vignette 0.5:0.5 --effect-pixelate 3 --ring-color 5d4d7a --grace 2 --fade-in 0.7";
in

{
  def = ''
    <box orientation="v" space-evenly="false" class="power">
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
                <box class="face-img" style="background-image: url('{{homedir}}/.cache/.face.png');"></box>
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
}
