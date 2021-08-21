{ config, lib, pkgs, ... }:
let inherit (lib) fileContents;
in
{

  environment = {
    /*
      etc = {
      };
      pathsToLink = [ "/share/zsh" ];
    */

    systemPackages = with pkgs; [

      ### Packages
      # network manager
      # pipewire
      # xdg-desktop-portal-wlr

      # Network
      connman
      iwd
      # [opennic-up](https://github.com/kewlfft/opennic-up)

      #### Performance
      # * [nohang-desktop](https://github.com/hakavlad/nohang) (py)
      # * [prelockd](https://github.com/hakavlad/prelockd) (py)
      # * [memavaild](https://github.com/hakavlad/memavaild) (py)
      # * [precached](https://github.com/X3n0m0rph59/precached) (rs)
      # * [auto-cpufreq (laptop)](https://github.com/AdnanHodzic/auto-cpufreq) (py)
      # * [bustd](https://github.com/vrmiguel/bustd/)
      # * [gamemode](https://github.com/FeralInteractive/gamemode) (c)
      # * [resourced](https://gitlab.freedesktop.org/benzea/uresourced) (c)
      dbus-broker
      # * Set zram

      # Shells, Prompts, & Utilities
      zsh
      nushell
      ion
      starship
      exa
      fd
      ripgrep
      ripgrep-all
      bingrep
      tokei
      bat
      bat-extras.prettybat
      bat-extras.batman
      bat-extras.batgrep
      bat-extras.batdiff
      bat-extras.batwatch
      procs
      delta
      just
      jql
      skim
      hexyl
      zoxide
      rargs

      runiq
      rm-improved
      frawk
      mdcat
      choose
      lolcate-rs
      nix-index
      sd
      unstable.xcp
      cn
      hck
      ff
      xsv
      grex
      xxv

      bottom
      diskonaut
      hyperfine
      tealdeer
      manix

      # Terminal
      alacritty

      ### File Manager
      nautilus
      # thunar (daemon mode is nice) (icon issues under wayland)
      # pcmanfm (daemon mode is nice)

      # Night Mode
      gammastep
      wlsunset

      # Screen{shots,recording}/Content Consumption
      grim
      swappy
      slurp
      ffmpeg
      highlight
      immagemagick
      exiftool
      wshowkeys
      flameshot

      mpv
      gnome-podcast
      imv

      libsForQt5.elisa
      haruna
      # [lyriek](https://github.com/bartwillems/lyriek)
      unstable.newsflash

      # Office
      antiword
      cdrtools
      odt2txt
      # [doc2txt](https://archlinux.org/packages/community/any/docx2txt/)
      zathura

      # Display Management
      # [wlay](https://github.com/atx/wlay)
      kanshi
      # [Disman](https://gitlab.com/kwinft/disman)

      #### Misc
      #[archivefs](https://github.com/bugnano/archivefs)
      # * Archivefs is a read-only FUSE filesystem for mounting compressed archives, inspired by archivemount.

      swayidle

      # [wpass](https://github.com/icewind1991/wpass)
      # * Pass menu

      rbw

      # [popsicle](https://github.com/pop-os/popsicle)
      # *  Multiple USB File Flasher
      # [tau](https://gitlab.gnome.org/World/Tau)
      # * Simple graphical text editor
      # [polaris](https://github.com/agersant/polaris)
      # * music server
      # [vaultwarden](https://github.com/dani-garcia/vaultwarden)
      # * Alternative implementation of the Bitwarden server API written in Rust and compatible with upstream Bitwarden clients
      # [markdown-rs](https://github.com/nilgradisnik/markdown-rs)
      # * Markdown editor
      unstable.zellij
      unstable.helix

    ];
  };


  services = {
    earlyoom.enable = false;
    rice.enable = true;
    irqbalance.enable = true;
  };

  systemd = {
    services = {
      dbus-broker.enable = true;
      dbus.enable = false;
    };
    user.services = {
      dbus-broker.enable = true;
      dbus.enable = false;
    }
      };


    zramSwap = {
      enable = true;
      algorithm = "zstd";
    };
  }
