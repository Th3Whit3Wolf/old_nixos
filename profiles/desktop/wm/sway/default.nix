{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs;
    [
      firefox-wayland
      alacritty
      wofi
      kanshi
      swaylock-effects
      swayidle
      brightnessctl
      grim
      sway-contrib.grimshot
      imv
      slurp
      qt5.qtwayland
      breeze-qt5 # For them sweet breeze cursors
      nwg-launchers
    ];
}
