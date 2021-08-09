{ config, lib, pkgs, ... }:

{
  config = {
    programs.sway = {
      enable = true;
      #wrapperFeatures.gtk = true;
    };
    xdg = {
      portal = {
        enable = true;
        #extraPortals = with pkgs; [
        #xdg-desktop-portal-wlr
        #xdg-desktop-portal-gtk
        #];
        #gtkUsePortal = true;
      };
    };
  };
}
