{ config, pkgs, lib, options, ... }: {
  environment.systemPackages = with pkgs; [
    acpi
    lm_sensors
    wirelesstools
    pciutils
    usbutils
    iwd
    (pkgs.writeShellScriptBin "add-network.sh" ''
      dir=/var/lib/iwd
      mkdir -p $dir
      # Only SSIDs with alphanumeric characters and -_ are allowed. The rest have to
      # be hex encoded. However, iwctl has a bug that doesn't allow SSIDs with - or _.
      # Hence this script.
      if [[ $1 =~ ^[0-9a-zA-Z_-]+$ ]]; then
          filename="$1.psk"
      else
          # Convert SSID into hexadecimal representation for filename
          filename="=$(echo -n "$1" | ${pkgs.coreutils}/bin/od -A n -t x1 | ${pkgs.gnused}/bin/sed 's/ //g').psk"
      fi
      output=$(${pkgs.wpa_supplicant}/bin/wpa_passphrase "$1" "$2")
      cat > "$dir/$filename" << EOF
      [Security]
      PreSharedKey=$(echo $output | ${pkgs.gnugrep}/bin/grep -o -P '[^#]psk=\K\w+')
      EOF
    '')
  ];

  # better timesync for unstable internet connections
  services = {
    timesyncd.enable = false;
    ntp.enable = false;
    chrony = {
      enable = true;
      servers = [
        "0.uk.pool.ntp.org"
        "1.uk.pool.ntp.org"
        "2.uk.pool.ntp.org"
        "3.uk.pool.ntp.org"
        "0.nixos.pool.ntp.org"
        "1.nixos.pool.ntp.org"
        "2.nixos.pool.ntp.org"
        "3.nixos.pool.ntp.org"
      ];
      serverOption = "offline";
      extraConfig = ''
        # In first three updates step the system clock instead of slew
        # if the adjustment is larger than 1 second.
        makestep 1.0 3
        pool time.nist.gov iburst
        server time.cloudflare.com nts iburst
        pool nixos.pool.ntp.org iburst
        pool pool.ntp.org iburst
        pool amazon.pool.ntp.org iburst
        initstepslew ${toString config.services.chrony.initstepslew.threshold} ${lib.concatStringsSep " " config.networking.timeServers}
        # Enable kernel synchronization of the real-time clock (RTC).
        rtcsync
        ntsdumpdir /var/lib/chrony/nts
      '';
    };
    tlp = {
      enable = true;
      settings = {
        "SOUND_POWER_SAVE_ON_AC" = 0;
        "SOUND_POWER_SAVE_ON_BAT" = 1;
        "SOUND_POWER_SAVE_CONTROLLER" = "Y";
        "BAY_POWEROFF_ON_AC" = 0;
        "BAY_POWEROFF_ON_BAT" = 1;
        "DISK_APM_LEVEL_ON_AC" = "254 254";
        "DISK_APM_LEVEL_ON_BAT" = "128 128";
        "DISK_IOSCHED" = "none none";
        "SATA_LINKPWR_ON_AC" = "med_power_with_dipm max_performance";
        "SATA_LINKPWR_ON_BAT" = "min_power";
        "MAX_LOST_WORK_SECS_ON_AC" = 15;
        "MAX_LOST_WORK_SECS_ON_BAT" = 60;
        "NMI_WATCHDOG" = 0;
        "WIFI_PWR_ON_AC" = "off";
        "WIFI_PWR_ON_BAT" = "on";
        "WOL_DISABLE" = "Y";
        "CPU_SCALING_GOVERNOR_ON_AC" = "powersave";
        "CPU_SCALING_GOVERNOR_ON_BAT" = "powersave";
        "CPU_MIN_PERF_ON_AC" = 0;
        "CPU_MAX_PERF_ON_AC" = 100;
        "CPU_MIN_PERF_ON_BAT" = 0;
        "CPU_MAX_PERF_ON_BAT" = 50;
        "CPU_BOOST_ON_AC" = 1;
        "CPU_BOOST_ON_BAT" = 1;
        "SCHED_POWERSAVE_ON_AC" = 0;
        "SCHED_POWERSAVE_ON_BAT" = 1;
        "ENERGY_PERF_POLICY_ON_AC" = "performance";
        "ENERGY_PERF_POLICY_ON_BAT" = "power";
        "RESTORE_DEVICE_STATE_ON_STARTUP" = 0;
        "RUNTIME_PM_ON_AC" = "on";
        "RUNTIME_PM_ON_BAT" = "auto";
        "PCIE_ASPM_ON_AC" = "default";
        "PCIE_ASPM_ON_BAT" = "powersupersave";
        "USB_AUTOSUSPEND" = 1;
      };
    };
    udev = {
      extraRules = ''
        # Save Power
        ACTION=="add", SUBSYSTEM=="scsi_host", KERNEL=="host*", ATTR{link_power_management_policy}="med_power_with_dipm"
      '';
    };
  };
  networking = {
    networkmanager = {
      enable = true;
      dispatcherScripts = [
        {
          source = pkgs.writeText "10-chrony" ''
            INTERFACE=$1
            STATUS=$2
            # Make sure we're always getting the standard response strings
            LANG='C'
            CHRONY=${pkgs.chrony}/bin/chronyc
            chrony_cmd() {
              echo "Chrony going $1."
              exec $CHRONY -a $1
            }
            nm_connected() {
              [ "''$(${pkgs.networkmanager}/bin/nmcli -t --fields STATE g)" = 'connected' ]
            }
            case "$STATUS" in
              up)
                chrony_cmd online
              ;;
              vpn-up)
                chrony_cmd online
              ;;
              down)
                # Check for active interface, take offline if none is active
                nm_connected || chrony_cmd offline
              ;;
              vpn-down)
                # Check for active interface, take offline if none is active
                nm_connected || chrony_cmd offline
              ;;
            esac
          '';
          type = "basic";
        }
        {
          source = pkgs.writeText "disable-wireless-when-wired" ''
              INTERFACE=$1
              STATUS=$2
              # Make sure we're always getting the standard response strings
              LANG='C'

              nm_wifi() {
                [ "''$${pkgs.networkmanager}/bin/nmcli radio wifi $1 ]
              }

              case ''${INTERFACE} in
                eth*|en*)
                    case ''${STATUS} in
                        up)
                            nm_wifi off
                            ;;
                        down)
                            nm_wifi on
                            ;;
                    esac
                    ;;
            esac
          '';
          type = "basic";
        }
      ];
      wifi = {
        powersave = true;
        backend = "iwd";
      };
    };
    timeServers = [
      # NIST
      "time.nist.gov"
      # Cloudflare
      "time.cloudflare.com"
    ] ++ options.networking.timeServers.default;
    useDHCP = false;
  };

}
