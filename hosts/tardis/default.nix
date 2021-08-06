{ lib, modulesPath, pkgs, suites, hardware, profiles, ... }:
let
  inherit (builtins) toFile readFile;
  inherit (lib) fileContents mkForce;

  accessToken = "github.com=" + (fileContents ./secrets/access_token);
in
{
  imports = [ ./users ./hardware-configuration.nix ] ++ suites.tardis;

  hardware = {
    opengl = {
      enable = true;
      extraPackages = with pkgs; [ vaapiVdpau libvdpau-va-gl ];
      driSupport = true;
      driSupport32Bit = true;
    };
  };

  home-manager.useUserPackages = true;

  nix = {
    /*
      * Maximum Processes = maxJobs * buildCores
      *
      * 2 derivations will be built at once,
      * each given access to 3 cores.
    */
    maxJobs = 2;
    buildCores = 3;
    allowedUsers = [ "@users" ];
    extraOptions = ''
      access-tokens = "${accessToken}";
    '';
  };

  security = {
    lockKernelModules = true;
    # Prevent replacing the running kernel w/o reboot
    protectKernelImage = true;
    forcePageTableIsolation = true;
    rtkit.enable = true;

    # This is required by podman to run containers in rootless mode.
    #unprivilegedUsernsClone = config.virtualisation.containers.enable;

    virtualisation.flushL1DataCache = "always";
    apparmor = {
      enable = true;
      killUnconfinedConfinables = true;
    };

    pam.services.greetd = {
      enableGnomeKeyring = true;
    };
  };

  services = {
    dbus.packages = with pkgs; [ gnome3.dconf gcr ];
    gvfs.enable = true;
    gnome.gnome-keyring.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
      jack.enable = true;
    };
    irqbalance.enable = true;
    rice.enable = true;

    greetd = {
      enable = true;
      restart = false;
      settings = {
        default_session = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --cmd sway";
          user = "greeter";
        };
      };
    };
  };
  networking = {
    networkmanager = {
      enable = true;
      packages = with pkgs; [ gnome3.networkmanager-openvpn ];
    };

    firewall = {
      enable = true; # Enable firewall
      allowedTCPPorts = [
        #22070                           # Syncthing relay
        #22067                           # Syncthing relay
      ];
      allowedUDPPorts = [

      ];
    };
  };
  programs.seahorse.enable = true;
  sound.enable = true;
  time.timeZone = "Europe/London";

  environment = {
    #memoryAllocator.provider = "scudo";
    #variables.SCUDO_OPTIONS = "ZeroContents=1";
    etc = {
      "greetd/environment" = {
        text = ''
          ${pkgs.sway}/bin/sway
          ${pkgs.zsh}/bin/zsh
        '';
      };
      "greetd/swayconfig" = {
        text = ''
          # Config for sway
          # only enable this if every app you use is compatible with wayland
          # xwayland disable

          exec ${pkgs.greetd.wlgreet}/bin/wlgreet

          # Need to created wayland-logout package
          # Should be simple https://github.com/soreau/wayland-logout
          #exec ''${pkgs.qtgreet}/bin/qtgreet && wayland-logout
          #; loginctl terminate-user $USER

        '';
      };
    };
  };
}
