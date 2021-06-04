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
  environment = {
    systemPackages = with pkgs; [
      gnome3.adwaita-icon-theme # Icons for gnome packages that sometimes use them but don't depend on them
      gnome3.nautilus
      gnome3.nautilus-python
      gnome3.sushi
      mesa
      sway
      river
    ];
  };

  services = {
    dbus.packages = [ pkgs.gnome3.dconf ];
    gvfs.enable = true;

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
}
