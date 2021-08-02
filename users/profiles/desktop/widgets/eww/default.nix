{ config, lib, pkgs, ... }:

let
  defs = lib.forEach
    (
      lib.mapAttrsToList (n: v: lib.removeSuffix ".nix" "${n}") (builtins.readDir ./definitions)
    )
    (x:
      ''<def name="${x}">
    ${(import (./definitions + "/${x}.nix") { lib = lib; pkgs = pkgs; }).def}
    </def>''
    );
in
{
  /*
    config = {
    xdg.configFile = {
    "eww/eww.scss" = {
    source = ./eww.scss;
    };
    "eww/eww.xml" = {
    source =./eww.xml;
    };
    };
    };
  */

  config.services.eww = {
    enable = true;
    isWayland = true;
    style = ./eww.scss;
    config = {
      definitions = defs;
      variables = {
        script-vars = {
          date = { text = "date"; };
          networking = {
            text = "nmcli -p -g {connection} | grep -e 'connected to' | sed -e 's/ .* //' -e 's/.*://'";
            interval = {
              quantity = 60;
              units = "s";
            };
          };
        };
        vars = { };
      };
      windows = {
        bar = {
          stacking = "bt";
          focusable = false;
          exclusive = true;
          geometry = {
            anchor = "top center";
            x = "0px";
            y = "0px";
            width = "100%";
            height = "12px";
          };
          widget = "bar";
        };
      };
    };
  };
}
