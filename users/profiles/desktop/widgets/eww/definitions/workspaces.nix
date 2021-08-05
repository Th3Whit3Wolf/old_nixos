{ lib, pkgs, ... }:

let
  moveToWorkspace = pkgs.writeScriptBin "moveToWorkspace" ''
    #!${pkgs.stdenv.shell}
    num=$1
    eww update current_workspace="$num"
    swaymsg "workspace number $num"
  '';
in

{
  def = ''
    <box class="workspaces" spacing="10" space-evenly="false" halign="center">
        <button class="{{ if current_workspace =~ '(^1 | 1 |^1$| 1$)' then 'active_workspace' else 'inactive_workspace'}}" onclick='bash -c "${moveToWorkspace}/bin/moveToWorkspace 1"'>1</button>
        <button class="{{ if current_workspace =~ '(^2 | 2 |^2$| 2$)' then 'active_workspace' else 'inactive_workspace'}}" onclick='bash -c "${moveToWorkspace}/bin/moveToWorkspace 2"'>2</button>
        <button class="{{ if current_workspace =~ '(^3 | 3 |^3$| 3$)' then 'active_workspace' else 'inactive_workspace'}}" onclick='bash -c "${moveToWorkspace}/bin/moveToWorkspace 3"'>3</button>
        <button class="{{ if current_workspace =~ '(^4 | 4 |^4$| 4$)' then 'active_workspace' else 'inactive_workspace'}}" onclick='bash -c "${moveToWorkspace}/bin/moveToWorkspace 4"'>4</button>
        <button class="{{ if current_workspace =~ '(^5 | 5 |^5$| 5$)' then 'active_workspace' else 'inactive_workspace'}}" onclick='bash -c "${moveToWorkspace}/bin/moveToWorkspace 5"'>5</button>
        <button class="{{ if current_workspace =~ '(^6 | 6 |^6$| 6$)' then 'active_workspace' else 'inactive_workspace'}}" onclick='bash -c "${moveToWorkspace}/bin/moveToWorkspace 6"'>6</button>
        <button class="{{ if current_workspace =~ '(^7 | 7 |^7$| 7$)' then 'active_workspace' else 'inactive_workspace'}}" onclick='bash -c "${moveToWorkspace}/bin/moveToWorkspace 7"'>7</button>
        <button class="{{ if current_workspace =~ '(^8 | 8 |^8$| 8$)' then 'active_workspace' else 'inactive_workspace'}}" onclick='bash -c "${moveToWorkspace}/bin/moveToWorkspace 8"'>8</button>
        <button class="{{ if current_workspace =~ '(^9 | 9 |^9$| 9$)' then 'active_workspace' else 'inactive_workspace'}}" onclick='bash -c "${moveToWorkspace}/bin/moveToWorkspace 9"'>9</button>
        <button class="{{ if current_workspace =~ '(^10 | 10 |^10$| 10$)' then 'active_workspace' else 'inactive_workspace'}}" onclick='bash -c "${moveToWorkspace}/bin/moveToWorkspace 10"'>10</button>
    </box>
  '';

  vars = {
    current_workspace = "1";
  };
}
