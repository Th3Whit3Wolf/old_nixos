{ config, lib, pkgs, ... }:
let inherit (lib) fileContents;
in
{
  imports = [ ../cachix ];

  environment = {
    systemPackages = with pkgs; [
      binutils
      cached-nix-shell
      compsize
      coreutils
      curl
      direnv
      dnsutils
      dosfstools
      gnumake
      iputils
      jq
      manix
      moreutils
      nix-index
      nmap
      openssl
      usbutils
      utillinux
      wget
      whois

      # Compression
      commonsCompress
      lhasa
      lrzip
      lzop
      p7zip
      pbzip2
      pigz
      unrar
      unzip

      # Codecs
      a52dec
      faac
      faad2
      flac
      gst_all_1.gst-libav
      gst_all_1.gst-plugins-bad
      gst_all_1.gst-plugins-base
      gst_all_1.gst-plugins-good
      gst_all_1.gst-plugins-ugly
      gst_all_1.gst-vaapi
      gst_all_1.gstreamer
      lame
      libde265
      libdv
      libmad
      libmpeg2
      libtheora
      libvorbis
      wavpack
      xvidcore

      # Rust Tools
      bat
      bat-extras.prettybat
      bat-extras.batman
      bat-extras.batgrep
      bat-extras.batdiff
      bat-extras.batwatch
      bingrep
      bottom
      diskonaut
      du-dust
      exa
      fd
      hexyl
      hyperfine
      just
      nushell
      procs
      ripgrep
      skim
      tealdeer
      tokei
      xsv
      xxv
      zoxide

      # Miscellaneous
      kibi
      micro
    ];
  };

  fonts = {
    fonts = with pkgs; [ powerline-fonts dejavu_fonts ];

    fontconfig.defaultFonts = {
      monospace = [ "DejaVu Sans Mono for Powerline" ];
      sansSerif = [ "DejaVu Sans" ];
    };
  };

  nix = {
    autoOptimiseStore = true;
    gc.automatic = true;
    optimise.automatic = true;
    useSandbox = true;
    allowedUsers = [ "@wheel" ];
    trustedUsers = [ "root" "@wheel" ];
    systemFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
    extraOptions = ''
      min-free = 536870912
      keep-outputs = true
      keep-derivations = true
      fallback = true
    '';
  };

  environment = {
    etc = {
      # Automatic log out from virtual consoles
      "profile.d/shell-timeout.sh".text = '' "TMOUT="\$(( 60*30 ))";
      [ -z "\$DISPLAY" ] && export TMOUT;
        case \$( /usr/bin/tty ) in
    /dev/tty[0-9]*) export TMOUT;;
        esac
    '';
    };
  };

  services.earlyoom.enable = true;
}
