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
      ssh.enable = true;
      # Needed occasionally to help the parental units with PC problems
      # teamviewer.enable = true;
    };
    theme.active = "alucard";
  };

  ## Local config
  programs = {
    ssh.startAgent = true;
    nm-applet.enable = true;
  };
  services = {
    openssh.startWhenNeeded = true;
    chrony.enable = true;
    tlp.enable = true;
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
      wifi.powersave = true;
    };
    useDHCP = false;
    timeServers = [
      "0.uk.pool.ntp.org"
      "1.uk.pool.ntp.org"
      "2.uk.pool.ntp.org"
      "3.uk.pool.ntp.org"
      "0.nixos.pool.ntp.org"
      "1.nixos.pool.ntp.org"
      "2.nixos.pool.ntp.org"
      "3.nixos.pool.ntp.org"
    ];
  };
  
  environment.systemPackages = [ pkgs.irqbalance pkgs.dbus-broker ];
  user.packages = with pkgs;
    [
      #gnome-podcasts
      lollypop
    ];
}
