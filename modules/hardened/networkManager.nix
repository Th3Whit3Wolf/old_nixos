{ config, lib, ... }:

{
  config = lib.mkIf (config.networking.networkmanager.enable) {
    systemd.services = {
      NetworkManager.serviceConfig = {
        # Used as root directory
        #RuntimeDirectory = "NetworkManager";
        #RootDirectory = "/run/NetworkManager";
        RestrictAddressFamilies = [ "AF_INET" "AF_INET6" "AF_NETLINK" "AF_PACKET" "AF_UNIX" ];
        ProtectHome = true;
        #ProtectSystem = "strict";
        #ProtectProc = "invisible";
        #ReadWritePaths = ["/etc" "/proc/sys/net" "/run/resolvconf" "/var/lib/NetworkManager" "/var/run/NetworkManager"  ];
        PrivateTmp = true;
        #PrivateDevices = true;
        #ProtectKernelTunables = true;
        #ProtectKernelModules = true;
        #ProtectKernelLogs = true;
        UMask = 077;
        #CapabilityBoundingSet = ["~CAP_SYS_ADMIN" "CAP_SETUID" "CAP_SETGID" "CAP_SYS_CHROOT"];
        NoNewPrivileges = true;
        #ProtectHostname = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        #RestrictNamespaces = true;
        #LockPersonality = true;
        #MemoryDenyWriteExecute = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        #SystemCallFilter = ["@system-service" "~@resources" "@privileged"];
        #SystemCallArchitectures = "native";
        BindReadOnlyPaths = [
          "/nix/store"
          "/etc/NetworkManager"
        ];
      };
      NetworkManager-dispatcher.serviceConfig = {
        ProtectHome = true;
      };
    };
  };
}

# https://madaidans-insecurities.github.io/guides/linux-hardening.html#ipv6-networkmanager
