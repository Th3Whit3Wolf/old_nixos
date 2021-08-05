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
    <box class="calendar" orientation="h" space-evenly="false">
        <box class="calendar" orientation="v" space-evenly="false">
            <label class="calendar-year" text="{{year_cal}}" halign="start"/>
            <label class="calendar-date" text="{{weekday_cal}}, {{month_cal}} {{day_num_cal}}" halign="start"/>
            <calendar show-day-names="true" show-heading="true" halign="start" valign="center" onclick="eww close calendar"/>
        </box>
        <box class="calendar-info" orientation="v" space-evenly="false" halign="start" valign="center" hexpand="true">
            <box class="quote-container" orientation="v" hexpand="false" vexpand="true">
                <label class="quote" halign="start" text="&quot;{{quote-text}}&quot;" wrap="true" width="20"/>
                <box orientation="h">
                    <box class="quote-info" orientation="h" space-evenly="false">
                        <label class="quote-author" text="- {{quote-author}} "/>
                        <label class="quote-title" text="({{quote-title}})"/>
                    </box>
                    <box orientation="v" space-evenly="false" valign="center">
                        <label class="quote-number" text="#{{quote-number}}" halign="end"/>
                        <label class="quote-time" text="{{quote-time}} min until new quote" halign="end"/>
                    </box>
                </box>
            </box>
            <box class="calendar-container" orientation="v" space-evenly="false">
                <box space-evenly="false" orientation="h">
                    <label class="next-app-text" text="Next appointment &quot;"/>
                    <label class="next-app" text="{{next_appointment}}"/>
                    <label class="next-app-text" text="&quot; in "/>
                    <label class="next-app" text="{{next_appointment_time}}"/>
                </box>
                <expander name="Appointments" vexpand="true" expanded="false">
                    <box orientation="h" space-evenly="false">
                        <label class="app-times" text="{{appointment_times}}"/>
                        <label class="app-names" text="{{appointment_names}}"/>
                    </box>
                </expander>
                <expander name="Tasks" vexpand="true" expanded="false">
                    <label class="todo-names" text="{{todo}}" halign="start"/>
                </expander>
            </box>
        </box>
    </box>
  '';

  script-vars = {
    year_cal = {
      text = ''date "+%Y"'';
    };
    month_cal = {
      text = ''date "+%b"'';
    };
    weekday_cal = {
      text = ''date "+%a"'';
    };
    day_num_cal = {
      text = ''date "+%d"'';
    };
  };
  vars = {
    next_appointment_time = "01h 43mins";
    next_appointment = "Sleep";
    appointment_names = "Caffeine";
    appointment_time = "10h 23mins";
    todo = "Space 100";
  };
}
