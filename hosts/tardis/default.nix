{ pkgs, config, lib, ... }: {
  imports = [ ../home.nix ./hardware-configuration.nix ];

  ## Modules
  modules = {
    desktop = {
      sway.enable = true;
      bar.way.enable = true;
      apps = {
        #discord.enable = true;
        rofi.enable = true;
        # godot.enable = true;
        #signal.enable = true;
      };
      browsers = {
        default = "firefox";
        #brave.enable = false;
        firefox.enable = true;
        #qutebrowser.enable = false;
      };
      gaming = {
        # steam.enable = true;
        # emulators.enable = true;
        # emulators.psx.enable = true;
      };
      media = {
        daw.enable = true;
        documents.enable = true;
        graphics.enable = true;
        mpv.enable = true;
        recording.enable = true;
        # spotify.enable = true;
      };
      term = {
        default = "xst";
        alacritty.enable = true;
      };
      vm = { qemu.enable = false; };
    };
    dev = {
      lang = {
        cc.enable = true;
        go.enable = true;
        lua.enable = true;
        nix.enable = true;
        node.enable = true;
        python.enable = true;
        rust.enable = true;
	shell.enable = true;
      };
      vcs = { git.enable = true; };
    };
    editor = {
      default = "nvim";
      emacs.enable = false;
      nvim.enable = true;
      vscode.enable = true;
    };
    shell = {
      adl.enable = true;
      bitwarden.enable = true;
      gnupg.enable = true;
      tmux.enable = true;
      zsh.enable = true;
    };
    services = {
      psd.enable = true;
      ssh.enable = true;
      # Needed occasionally to help the parental units with PC problems
      # teamviewer.enable = true;
    };
    theme.active = "spaceDark";
  };

  ## Local config
  programs = {
    ssh.startAgent = true;
    nm-applet.enable = true;
  };
  services = {
    openssh.startWhenNeeded = true;
    # Disable NTP, enable chrony...
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

	# Enable kernel synchronization of the real-time clock (RTC).
	rtcsync
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
    sshguard.enable = true;
    irqbalance.enable = true;
    udev = {
      extraRules = ''
        # set scheduler for NVMe
        ACTION=="add|change", KERNEL=="nvme[0-9]*", ATTR{queue/scheduler}="none"
        # set scheduler for SSD and eMMC
        ACTION=="add|change", KERNEL=="sd[a-z]|mmcblk[0-9]*", ATTR{queue/rotational}=="0", ATTR{queue/scheduler}="mq-deadline"
        # set scheduler for rotating disks
        ACTION=="add|change", KERNEL=="sd[a-z]", ATTR{queue/rotational}=="1", ATTR{queue/scheduler}="bfq"
        # Save Power
	ACTION=="add", SUBSYSTEM=="scsi_host", KERNEL=="host*", ATTR{link_power_management_policy}="med_power_with_dipm"
      '';
    };   
  };

  networking = {
    networkmanager = {
      enable = true;
      dispatcherScripts = [{
	source = pkgs.writeText "10-chrony" ''
	  #!/bin/sh

	  INTERFACE=\$1
	  STATUS=\$2

	  # Make sure we're always getting the standard response strings
	  LANG='C'

	  CHRONY=${pkgs.chrony}/bin/chrony

	  chrony_cmd() {
	      echo "Chrony going \$1."
	      exec \$CHRONY -a \$1
	  }

	  nm_connected() {
	      [ "\$(nmcli -t --fields STATE g)" = 'connected' ]
	  }

	  case "\$STATUS" in
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
      }];
      wifi.powersave = true;
    };
    useDHCP = false;
    
  };
  
  environment.systemPackages = [ pkgs.irqbalance pkgs.dbus-broker ];
  user.packages = with pkgs;
    [
      #gnome-podcasts
      lollypop
      git-crypt
    ];
}
