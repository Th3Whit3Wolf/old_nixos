{ config, lib, pkgs, ... }:

{
  config = {
    programs.fuse.userAllowOther = true;

    environment = {
      etc = {
        nixos.source = "/persist/etc/nixos";
        "NetworkManager/system-connections".source = "/persist/etc/NetworkManager/system-connections";
        adjtime.source = "/persist/etc/adjtime";
        NIXOS.source = "/persist/etc/NIXOS";
        machine-id.source = "/persist/etc/machine-id";
        "profile.d/shell-timeout.sh".text = '' "TMOUT="\$(( 60*30 ))";
      [ -z "\$DISPLAY" ] && export TMOUT;
        case \$( /usr/bin/tty ) in
    /dev/tty[0-9]*) export TMOUT;;
        esac
    '';
      };
    };

    systemd.tmpfiles.rules = [
      "L /var/lib/NetworkManager/secret_key - - - - /persist/var/lib/NetworkManager/secret_key"
      "L /var/lib/NetworkManager/timestamps - - - - /persist/var/lib/NetworkManager/timestamps"
      "L /var/lib/sshguard/blacklist.db - - - - /persist/var/lib/sshguard/blacklist.db"
    ];
  };
}
