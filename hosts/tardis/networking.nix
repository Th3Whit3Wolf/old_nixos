{ config, lib, pkgs, modulesPath, ... }:

{
  config = {
    /*
      services.connman = {
      enable = true;
      package = pkgs.connmanFull;
      wifi.backend = "iwd";
      enableVPN = true;
      };
    */

    networking = {
      firewall = {
        enable = true; # Enable firewall
        allowedTCPPorts = [
          #22070                           # Syncthing relay
          #22067                           # Syncthing relay
        ];
        allowedUDPPorts = [

        ];
      };

      networkmanager = {
        enable = true;
        packages = with pkgs; [ gnome3.networkmanager-openvpn networkmanagerapplet ];
      };
    };
  };
}
