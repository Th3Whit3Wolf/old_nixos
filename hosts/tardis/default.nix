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

  #age.sshKeyPaths = [ "/persist/home/doc/.ssh/id_ed25519" ];

  time.timeZone = "Europe/London";

  nix = {
    maxJobs = 8;
    extraOptions = ''
      access-tokens = "${accessToken}";
    '';
  };
  environment = {
    etc = {
      nixos.source = "/persist/etc/nixos";
      "NetworkManager/system-connections".source = "/persist/etc/NetworkManager/system-connections";
      adjtime.source = "/persist/etc/adjtime";
      NIXOS.source = "/persist/etc/NIXOS";
      machine-id.source = "/persist/etc/machine-id";
      "profile.d/shell-timeout.sh".text = '' "TMOUT="\$(( 60*30 ))";
      [ -z "\$DISPLAY" ] && export TMOUT;
        case \$( /usr/bin/tty ) in
    /dev/tty[0-9]*) export TMOUT;;
        esac
    '';
    };
    systemPackages = with pkgs; [
      sway
      swaylock-effects
      swayidle
      brightnessctl
      gnome3.adwaita-icon-theme # Icons for gnome packages that sometimes use them but don't depend on them
      gnome3.nautilus
      gnome3.nautilus-python
      gnome3.sushi
      mesa
      breeze-qt5 # For them sweet cursors
      imv
      #wl-clipboard
      kanshi
      mako
      grim
      sway-contrib.grimshot
      #wtype
      slurp
      wofi
      qt5.qtwayland
      #river
    ];
  };

  systemd.tmpfiles.rules = [
    "L /var/lib/NetworkManager/secret_key - - - - /persist/var/lib/NetworkManager/secret_key"
    "L /var/lib/NetworkManager/timestamps - - - - /persist/var/lib/NetworkManager/timestamps"
    "L /var/lib/sshguard/blacklist.db - - - - /persist/var/lib/sshguard/blacklist.db"
  ];

  programs.fuse.userAllowOther = true;

  services = {
    gvfs.enable = true;
    xserver = {
      enable = true;
      layout = "us";
      displayManager.gdm = {
        enable = true;
        wayland = false;
      };
    };
    dbus.packages = [ pkgs.gnome3.dconf ];
  };
}
