{ lib, modulesPath, pkgs, suites, hardware, profiles, ... }:
let
  inherit (builtins) toFile readFile;
  inherit (lib) fileContents mkForce;

  accessToken = fileContents ./secrets/access_token;
in
{
  imports = [
    ./users
    ./hardware-configuration.nix
  ] ++ suites.tardis;

  # Use the latest kernel
  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot = {
        configurationLimit = 10;
        enable = true;
      };
    };
  };

  time.timeZone = "Europe/London";

  nix = {
    maxJobs = 8;
    extraOptions = ''
      access-tokens = "${accessToken}";
    '';
  };

  services = {
    dbus.packages = [ pkgs.gnome3.dconf ];
    gvfs.enable = true;

    #greetd = {
    #  enable = true;
    #  restart = false;
    #  settings = {
    #    default_session = {
    #      command = "${pkgs.greetd.tuigreet}/bin/tuigreet --cmd sway";
    #      user = "greeter";
    #    };
    #  };
    #};
  };
}
