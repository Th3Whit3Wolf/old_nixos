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
    extraOptions = ''
      access-tokens = "${accessToken}";
    '';
  };

  security.rtkit.enable = true;

  services = {
    dbus.packages = [ pkgs.gnome3.dconf ];
    gvfs.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
      jack.enable = true;
    };

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

  sound.enable = true;
  time.timeZone = "Europe/London";
}
