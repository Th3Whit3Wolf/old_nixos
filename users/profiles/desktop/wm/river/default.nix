{ config, lib, pkgs, ... }:

let
  inherit (config.home) homeDirectory username;
  pactl = "${pkgs.pulseaudioFull}/bin/pactl";
  brightnessctl = "${pkgs.brightnessctl}/bin/brightnessctl";
  lockCommand =
    "${pkgs.swaylock-effects}/bin/swaylock --screenshots --clock --indicator --indicator-radius 100 --indicator-thickness 7 --effect-blur 7x5 --effect-vignette 0.5:0.5 --effect-pixelate 3 --ring-color 5d4d7a --grace 2 --fade-in 0.7";
in
{
  home.configFile = {
    "river/init" = {
      text = ''
#!/bin/sh
mod="Mod4"
riverctl map normal $mod Return spawn alacritty
riverctl map normal $mod W spawn firefox
# Mod+Q to close the focused view
riverctl map normal $mod Q close
# Mod+E to exit river
riverctl map normal $mod E exit
  '';
    };
  };
}
