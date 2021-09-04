{ config, lib, pkgs, ... }:
let inherit (lib) fileContents;
in
{
  imports = [ ../cachix ];

  env = { ZDOTDIR = "$HOME/.config/zsh"; };

  environment = {
    etc = {
      # Automatic log out from virtual consoles
      "profile.d/shell-timeout.sh".text = ''
        # Log user out in 30 minutes
        "TMOUT="\$(( 60*30 ))";
        [ -z "\$DISPLAY" ] && export TMOUT;
          case \$( /usr/bin/tty ) in /dev/tty[0-9]*)
            export TMOUT;;
          esac
      '';
    };
    pathsToLink = [ "/share/zsh" ];

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
    fontDir.enable = true;
    enableGhostscriptFonts = true;
    fontconfig = {
      cache32Bit = true;
      defaultFonts = {
        monospace = [ "DejaVu Sans Mono for Powerline" ];
        sansSerif = [ "DejaVu Sans" ];
      };

    };
    fonts = with pkgs; [
      ubuntu_font_family
      dejavu_fonts
      symbola
      noto-fonts
      noto-fonts-cjk
      font-awesome
      nerdfonts
    ];
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
}
