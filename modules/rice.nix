{ lib, config, pkgs, ... }:


with lib;

{
  options.services.rice = {
    enable = mkEnableOption "rice";
  };

  config = mkIf (config.services.rice.enable) {
    environment.systemPackages = [ pkgs.rice pkgs.procps ];
    systemd.services.rice = {
      description = "Rice - ANother Auto NICe daemon in Rust";
      after = [ "local-fs.target" ];
      startLimitBurst = 10;
      startLimitIntervalSec = 0;

      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.rice}/bin/rice ${pkgs.rice}/rules";
        Nice = -5;
        SuccessExitStatus = 143;
        OOMScoreAdjust = -999;
        Restart = "always";
        RestartSec = 10;
        CPUAccounting = true;
        MemoryHigh = "15M";
        MemoryMax = "30M";

        # Hardening
        ProtectSystem = true;
        ProtectHome = "full";
        PrivateTmp = "yes";
        PrivateDevices = true;
        ProtectClock = true;
        #ProtectKernelLogs = true;
        ProtectKernelModules = true;
        #ProtectKernelTunables = true;
        #CapabilityBoundingSet = [ "~CAP_SYS_PTRACE" "CAP_CHOWN" "CAP_FSETID" "CAP_SETFCAP" "CAP_SETUID" "CAP_SETGID" "CAP_SETPCAP" "CAP_SYS_NICE" "CAP_SYS_RAWIO" ];

        #ProcSubset = "pid";
        #RestrictAddressFamilies = "AF_NETLINK";
        NoNewPrivileges = true;

        RestrictSUIDSGID = true;
        #RestrictNamespaces = "cgroup";
        ProtectHostname = true;
        LockPersonality = true;
        MemoryDenyWriteExecute = true;

        # Filter system calls to those absolutely requrired for correct functioning.
        SystemCallErrorNumber = "EPERM";
        SystemCallFilter = [ "@system-service" "~@privileged" "~@resources" "@module" "@mount" "@reboot" "@swap" "@clock" "@obsolete" "@cpu-emulation" "@process" "@resources" ];

        # Required to see other processes
        #PrivateUsers = false;
        #ProtectProc = "default";

        # Required for the process-listener socket to work
        #PrivateNetwork = false;

        # Required for control groups (obviously)
        ProtectControlGroups = false;

        # Required for future use.
        #RestrictRealtime = false;
      };
      wantedBy = [ "local-fs.target" ];
    };
  };
}
