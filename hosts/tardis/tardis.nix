{ lib, modulesPath, pkgs, suites, hardware, profiles, ... }:
let
  inherit (builtins) toFile readFile;
  inherit (lib) fileContents mkForce;

  name = "Just the doctor";
in
{
  import = [
    ./users
  ];

  ### root password is empty by default ###
  #imports = profiles.laptop;

  time.timeZone = "Europe/London";

  boot = {
    initrd = {
      availableKernelModules = [
        "aesni_intel"
        "cryptd"
        "nvme"
        "xhci_pci"
        "ahci"
        "usb_storage"
        "sd_mod"
        "rtsx_pci_sdmmc"
      ];
      kernelModules = [ ];
      luks.devices."crypt".device =
        "/dev/disk/by-uuid/57d2784d-0fcb-471b-838f-cbcca73fda93";
    };
    extraModulePackages = [ ];
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.configurationLimit = 10;
      systemd-boot.enable = true;
    };
    kernelModules = [ "kvm-amd" ];
    kernelPackages = pkgs.linuxPackages_5_10;
    kernelParams = [
      # HACK Disables fixes for spectre, meltdown, L1TF and a number of CPU
      #      vulnerabilities. Don't copy this blindly! And especially not for
      #      mission critical or server/headless builds exposed to the world.
      "mitigations=off"

      # Prevents unneccesary infor being written to stdout durring boot.
      "quiet"

      "add_efi_memmap"
    ];

    # Refuse ICMP echo requests on my desktop/laptop; nobody has any business
    # pinging them, unlike my servers.
    kernel.sysctl."net.ipv4.icmp_echo_ignore_broadcasts" = 1;
  };

  fileSystems = {
    "/" = {
      device = "tmpfs";
      fsType = "tmpfs";
      options = [ "defaults" "size=2G" "mode=755" "nodev" "nosuid" "noexec" ];
    };

    "/nix" = {
      device = "/dev/disk/by-uuid/55e7ba18-7d5d-41b5-9c11-3de4cfda1b7a";
      fsType = "btrfs";
      options = [
        "subvol=@nix"
        "ssd"
        "compress=zstd"
        "space_cache=v2"
        "discard=async"
        "autodefrag"
        "noatime"
        "nodev"
        "nosuid"
      ];
    };

    "/persist" = {
      device = "/dev/disk/by-uuid/55e7ba18-7d5d-41b5-9c11-3de4cfda1b7a";
      fsType = "btrfs";
      options = [
        "subvol=@persist"
        "ssd"
        "compress=zstd"
        "space_cache=v2"
        "discard=async"
        "autodefrag"
        "noatime"
        "nodev"
        "nosuid"
      ];
      neededForBoot = true;
    };

    "/var/log" = {
      device = "/dev/disk/by-uuid/55e7ba18-7d5d-41b5-9c11-3de4cfda1b7a";
      fsType = "btrfs";
      options = [
        "subvol=@log"
        "ssd"
        "compress=zstd"
        "space_cache=v2"
        "discard=async"
        "autodefrag"
        "noatime"
        "nodev"
        "nosuid"
        "noexec"
      ];
      neededForBoot = true;
    };

    "/.snapshots" = {
      device = "/dev/disk/by-uuid/55e7ba18-7d5d-41b5-9c11-3de4cfda1b7a";
      fsType = "btrfs";
      options = [
        "subvol=@snapshots"
        "ssd"
        "compress=zstd"
        "space_cache=v2"
        "discard=async"
        "autodefrag"
        "noatime"
        "nodev"
        "nosuid"
        "noexec"
      ];
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/D217-5F2C";
      fsType = "vfat";
      options = [ "nodev" "noexec" "nosuid" "nodev" "nosuid" "noexec" ];
    };
  };

  zramSwap = {
    enable = true;
    algorithm = "zstd";
  };

  swapDevices = [ ];

  nix.maxJobs = lib.mkDefault 8;
  environment.etc = {
    nixos.source = "/persist/etc/nixos";
    "NetworkManager/system-connections".source = "/persist/etc/NetworkManager/system-connections";
    adjtime.source = "/persist/etc/adjtime";
    NIXOS.source = "/persist/etc/NIXOS";
    machine-id.source = "/persist/etc/machine-id";
  };
}
