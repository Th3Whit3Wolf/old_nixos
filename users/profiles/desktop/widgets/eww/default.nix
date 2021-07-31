{ config, lib, pkgs, ... }:

{
  config.services.eww = {
    enable = true;
    isWayland = true;
    config = {
      definitions = {
        clock = {
          box = {
            contents = "The time is: {{my_time}} currently.";
          };
        };
        main = {
          box = {
            content = {
              name = "clock";
              args = {
                my_time = "date";
              };
            };
          };
        };
      };
      variables = {
        script-vars = {
          date = { text = "date"; };
        };
        vars = { };
      };
      windows = {
        main = {
          stacking = "fg";
          focusable = "false";
          screen = 1;
          geometry = {
            anchor = "top left";
            x = "300px";
            y = "50%";
            width = "25%";
            height = "20px";
          };
          reserve = {
            side = "left";
            distance = "50px";
          };
          widget = "main";
        };
      };
    };
  };
}
