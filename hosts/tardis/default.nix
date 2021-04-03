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
    editors = {
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
  programs.ssh.startAgent = true;
  services = {
    openssh.startWhenNeeded = true;
    chrony.enable = true;
  };

  networking = {
    networkmanager.enable = true;
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

  environment.systemPackages = with pkgs;
    [
      #gnome-podcasts
      lollypop
    ];
}
