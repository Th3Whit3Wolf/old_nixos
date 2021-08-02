{ lib, pkgs, ... }:


{
  def = ''
    <box class="workspaces" spacing="10" space-evenly="false" halign="center">
        <button class="workspaces_btn" onclick='swaymsg "workspace number 1"'>1</button>
        <button class="workspaces_btn" onclick='swaymsg "workspace number 2"'>2</button>
        <button class="workspaces_btn" onclick='swaymsg "workspace number 3"'>3</button>
        <button class="workspaces_btn" onclick='swaymsg "workspace number 4"'>4</button>
        <button class="workspaces_btn" onclick='swaymsg "workspace number 5"'>5</button>
        <button class="workspaces_btn" onclick='swaymsg "workspace number 6"'>6</button>
        <button class="workspaces_btn" onclick='swaymsg "workspace number 7"'>7</button>
        <button class="workspaces_btn" onclick='swaymsg "workspace number 8"'>8</button>
        <button class="workspaces_btn" onclick='swaymsg "workspace number 9"'>9</button>
        <button class="workspaces_btn" onclick='swaymsg "workspace number 10"'>10</button>
    </box>
  '';
}
