{ lib, pkgs, ... }:
let
  dsq = "''";
in
{
  def = ''
    <box class="notification" style="margin: 10px; padding: 5px 0px 5px 0px;" orientation="v" spacing="0" space-evenly="false">
        <box halign="fill" style="margin: 0 5px 0px 5px;" orientation="h" spacing="10" space-evenly="true" class="header">
          <button onclick="eww close notification" halign="start" style="font-weight: bold; padding: 5px; font-size: 15px; color: #dcbb8c">Notification Center</button>
          <button onclick="eww update notificationsContent=${dsq}" halign="end" style="background-color: #333232; padding: 0px 10px 0px 10px; font-size: 26px; border-radius: 5px;"></button>
        </box>
        <notification/>
      </box>
  '';
}
