{ lib, pkgs, ... }:


{
  def = ''
    <box class="notification" style="margin: 10px; padding: 5px 0px 5px 0px;" orientation="v" spacing="0" space-evenly="false">
        <box halign="fill" style="margin: 0 5px 0px 5px;" orientation="h" spacing="10" space-evenly="true" class="header">
          <button onclick="~/.config/eww/scripts/toggle" halign="start" style="font-weight: bold; font-family: Ubuntu Mono; padding: 5px; font-size: 15px; color: #dcbb8c">Notification Center</button>
          <button onclick="eww update content='\'" halign="end" style="background-color: #333232; padding: 0px 10px 0px 10px; font-size: 26px; border-radius: 5px;"></button>
        </box>
        <notifications/>
      </box>
  '';
}
