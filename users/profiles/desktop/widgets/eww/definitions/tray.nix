{ lib, pkgs, ... }:

let

  dsq = "''";
  getNetworkConn = pkgs.writeScriptBin "getNetworkConn" ''
    #!${pkgs.stdenv.shell}
    ACTIVE_CON=$(nmcli connect show  --active | tail -n +2)
    CURR_CON=$(iwgetid -r)

    if [ ! -z "$(echo $ACTIVE_CON | grep wifi)" ]; then
      echo "直 $CURR_CON"
    elif [ ! -z "$(echo $ACTIVE_CON | grep ethernet)" ]; then
      echo ""
    else
      echo ""
    fi
  '';

in
  /*
    * Volume
    * Battery
    * Bluetooth
    * Removable device
    * Network
    * Notifications
  */
{
  def = ''
    <box class="tray" orientation="h" space-evenly="false" spacing="12" halign="end">

      <button class="network" halign="fill" onclick="nm-connection-editor">
          {{network}}
      </button>

      <button class="notificationsIcon" onclick="eww open notification" halign="end">
        {{if notificationsContent == ${dsq} then '' else ''}}
      </button>

      <button class="time" onclick="eww open sidebar" halign="end">
        {{time}}
      </button>

    </box>
  '';

  script-vars = {
    time = {
      text = ''date "+%a %d %b|%H:%M"'';
      interval = {
        quantity = 15;
        units = "s";
      };
    };
    network = {
      text = ''bash -c "${getNetworkConn}/bin/getNetworkConn"'';
      interval = {
        quantity = 60;
        units = "s";
      };
    };
  };
}
