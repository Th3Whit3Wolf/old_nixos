{ lib, pkgs, ... }:


{
  def = ''
    <box class="tray" orientation="h" space-evenly="false" spacing="15" halign="end">

    <button style="color: #98967E;" halign="fill" onclick="nm-connection-editor &amp;">
        {{if network!='' then '直 connected' else '  disconnected'}}
  </button>

  <button class="time"
  style="font-size: 11px; font-weight: 600;"
  onclick="~/.config/eww/templates/power" halign="end">{{time}}</button>
  </box>
  '';
}
