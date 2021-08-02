{ lib, pkgs, ... }:

let

  dsq = "''";

in
{
  def = ''
      <box class="tray" orientation="h" space-evenly="false" spacing="15" halign="end">

      <button style="color: #98967E;" halign="fill" onclick="nm-connection-editor &amp;">
          {{if network!='\' then '直 connected' else '  disconnected'}}
    </button>

    <button
      style="font-size: 12px; font-weight: 600; color: #6f6f6f"
      onclick="eww open notification" halign="end">{{if notificationsContent == ${dsq} then '' else ''}}
    </button>
    <button class="time"
    style="font-size: 11px; font-weight: 600;"
    onclick="eww open sidebar" halign="end">{{time}}</button>
    </box>
  '';
}
