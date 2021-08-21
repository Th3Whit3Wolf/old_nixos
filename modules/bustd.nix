{ lib, config, pkgs, ... }:


with lib;

let
  cfg = config.services.bustd;
in
{
  options.services.bustd = {
    enable = mkEnableOption "rice";
  };

  config = mkIf cfg.enable {
    systemd.services.earlyoom = {
      description = "Bustd Daemon for Linux";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        StandardOutput = "null";
        ExecStart = "${pkgs.bustd}/bin/bustd";
      };
    };
  };
}
