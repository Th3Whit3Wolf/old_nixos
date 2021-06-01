{ lib, modulesPath, pkgs, suites, hardware, profiles, ... }:
let
  inherit (builtins) toFile readFile;
  inherit (lib) fileContents mkForce;
in
{
  imports = [
    ./users
    ./hardware-configuration.nix
  ] ++ suites.mobile;

  # Use the latest kernel
  boot = {
    kernelPackages = pkgs.linuxPackages_5_10;
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.configurationLimit = 10;
      systemd-boot.enable = true;
    };
  };


  time.timeZone = "Europe/London";

  nix.maxJobs = 8;
  environment.etc = {
    nixos.source = "/persist/etc/nixos";
    "NetworkManager/system-connections".source = "/persist/etc/NetworkManager/system-connections";
    adjtime.source = "/persist/etc/adjtime";
    NIXOS.source = "/persist/etc/NIXOS";
    machine-id.source = "/persist/etc/machine-id";
  };
}
