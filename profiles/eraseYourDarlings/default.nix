{ config, lib, pkgs, ... }:

{
  config = {
    programs.fuse.userAllowOther = true;

    environment = {
      persistence."/persist" = {
        directories = [
          "/etc/NetworkManager"
          "/etc/ssh"
          "/var/lib/bluetooth"
          "/var/lib/hercules-ci-agent"
          "/var/lib/NetworkManager"
          "/var/lib/sshguard"
          "/var/lib/systemd/coredump"
        ];

        files = [
          "/etc/adjtime"
          "/etc/machine-id"
          "/etc/NIXOS"
        ];
      };
    };
  };
}
