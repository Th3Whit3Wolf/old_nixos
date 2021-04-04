{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.desktop;
  isX11 = config.modules.desktop.bspwm.enable
    || config.modules.desktop.stumpwm.enable;
  isWayland = config.modules.desktop.sway.enable;
in {
  config = mkIf config.services.xserver.enable {
    assertions = [
      {
        assertion = (countAttrs (n: v: n == "enable" && value) cfg) < 2;
        message =
          "Can't have more than one desktop environment enabled at a time";
      }
      {
        assertion = let srv = config.services;
        in srv.xserver.enable || srv.sway.enable || !(anyAttrs
          (n: v: isAttrs v && anyAttrs (n: v: isAttrs v && v.enable)) cfg);
        message = "Can't enable a desktop app without a desktop environment";
      }
    ];

    user.packages = with pkgs;
      [
        neofetch
        procs
        openssl
        pavucontrol
        diskonaut
        unstable.bottom
        wget
	cached-nix-shell
        gnumake
        compsize
        fzf

	# Compression
	unzip
	unrar
	pigz
	pbzip2
	commonsCompress
	lhasa
	lrzip
	lzop
	p7zip

	# Codecs
	faac
	a52dec
	faad2
	flac
	libdv
	libmad
	libmpeg2
	libtheora
	libvorbis
	wavpack
	xvidcore
	libde265
	gst_all_1.gstreamer
	gst_all_1.gst-plugins-good
	gst_all_1.gst-plugins-bad
	gst_all_1.gst-plugins-ugly
	gst_all_1.gst-plugins-base
	gst_all_1.gst-libav
	gst_all_1.gst-vaapi
	lame

	# Some of my favorite rust tools
	ripgrep
	bat
	bat-extras.prettybat
	bat-extras.batman
	bat-extras.batgrep
	bat-extras.batdiff
	bat-extras.batwatch
	exa
	fd
	tokei
	skim
	xsv
	hyperfine
	just
	zoxide
	hexyl
	bingrep
	nushell
        my.spacemacs-theme
        (makeDesktopItem {
          name = "scratch-calc";
          desktopName = "Calculator";
          icon = "calc";
          exec =
            ''scratch "${tmux}/bin/tmux new-session -s calc -n calc qalc"'';
          categories = "Development";
        })
      ] ++ optionals isX11 [
        feh
        xclip
        xdotool
        xorg.xwininfo
        dunst
        rofi
        libqalculate
      ] ++ optionals isWayland [
        imv
        wl-clipboard
        kanshi
        mako
        grim
        sway-contrib.grimshot
        wtype
        slurp
        wofi
        qt5.qtwayland
      ];

    fonts = {
      fontDir.enable = true;
      enableGhostscriptFonts = true;
      fontconfig.cache32Bit = true;
      fonts = with pkgs; [
        my.san-francisco-font
        my.san-francisco-mono-font
        ubuntu_font_family
        dejavu_fonts
        symbola
        noto-fonts
        noto-fonts-cjk
        font-awesome
        nerdfonts
      ];
    };

    services.picom = mkIf isX11 {
      backend = "glx";
      vSync = true;
      opacityRules = [
        # "100:class_g = 'Firefox'"
        # "100:class_g = 'Vivaldi-stable'"
        "100:class_g = 'VirtualBox Machine'"
        # Art/image programs where we need fidelity
        "100:class_g = 'Gimp'"
        "100:class_g = 'Inkscape'"
        "100:class_g = 'aseprite'"
        "100:class_g = 'krita'"
        "100:class_g = 'feh'"
        "100:class_g = 'mpv'"
        "100:class_g = 'Rofi'"
        "100:class_g = 'Peek'"
        "99:_NET_WM_STATE@:32a = '_NET_WM_STATE_FULLSCREEN'"
      ];
      shadowExclude = [
        # Put shadows on notifications, the scratch popup and rofi only
        "! name~='(rofi|scratch|Dunst)$'"
      ];
      settings = {
        blur-background-exclude = [
          "window_type = 'dock'"
          "window_type = 'desktop'"
          "class_g = 'Rofi'"
          "_GTK_FRAME_EXTENTS@:c"
        ];

        # Unredirect all windows if a full-screen opaque window is detected, to
        # maximize performance for full-screen windows. Known to cause
        # flickering when redirecting/unredirecting windows.
        unredir-if-possible = true;

        # GLX backend: Avoid using stencil buffer, useful if you don't have a
        # stencil buffer. Might cause incorrect opacity when rendering
        # transparent content (but never practically happened) and may not work
        # with blur-background. My tests show a 15% performance boost.
        # Recommended.
        glx-no-stencil = true;

        # Use X Sync fence to sync clients' draw calls, to make sure all draw
        # calls are finished before picom starts drawing. Needed on
        # nvidia-drivers with GLX backend for some users.
        xrender-sync-fence = true;
      };
    };

    programs.dconf.enable = true;

    # XDG Portals
    xdg.portal = {
      enable = true;
      extraPortals = mkIf isWayland [ pkgs.xdg-desktop-portal-wlr ];
    };

    # Set Wayland variables
    env.QT_QPA_PLATFORM = mkIf isWayland "wayland";
    env.XDG_SESSION_TYPE = mkIf isWayland "wayland";
    env.QT_WAYLAND_FORCE_DPI = mkIf isWayland "96";
    env._JAVA_OPTIONS = mkIf isWayland
      "-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true -Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel -Dswing.crossplatformlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel";
    env._JAVA_AWT_WM_NONREPARENTING = mkIf isWayland "1";
    env.NO_AT_BRIDGE = mkIf isWayland "1";
    env.BEMENU_BACKEND = mkIf isWayland "wayland";

    # Make X11 XDG Compliant
    env.XAUTHORITY = mkIf isX11 "$XDG_RUNTIME_DIR/Xauthority";
    env.XINITRC = mkIf isX11 "$XDG_CONFIG_HOME/X11/xinitrc";
    env.XSERVERRC = mkIf isX11 "$XDG_CONFIG_HOME/X11/xserverrc";

    # Try really hard to get QT to respect my GTK theme.
    env.GTK_DATA_PREFIX = [ "${config.system.path}" ];
    env.QT_QPA_PLATFORMTHEME = if isX11 then "gtk2" else "qt5ct";
    qt5 = {
      style = "gtk2";
      platformTheme = "gtk2";
    };

    services.xserver.displayManager.sessionCommands = ''
      # GTK2_RC_FILES must be available to the display manager.
      export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc"
    '';
  };
}
