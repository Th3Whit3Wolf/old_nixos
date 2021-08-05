{ lib, pkgs, ... }:
let
  dsq = "''";
in
{
  def = ''
    <box class="notifications-center" orientation="v" spacing="0" space-evenly="false">
        <box halign="fill" orientation="h" spacing="10" space-evenly="true" class="header">
          <button class="title" onclick="eww close notification" halign="start">
            Notification Center
          </button>
          <button onclick="eww update notificationsContent=${dsq}" halign="end">
            
          </button>
        </box>
        <notification/>
      </box>
  '';
}
