{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.desktop.river;
  configDir = config.dotfiles.configDir;
  pactl = "${config.hardware.pulseaudio.package}/bin/pactl";
  bright = "${pkgs.brightnessctl}/bin/brightnessctl";
in {
  options.modules.desktop.river = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {

    environment = {
      sessionVariables = {
        _JAVA_AWT_WM_NONREPARENTING = "1";
        XDG_SESSION_TYPE = "wayland";
        QT_QPA_PLATFORM = "wayland";
	QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
      };
    };

    user.extraGroups = [ "video" ];
    user.packages = with pkgs; [
      my.eww
      my.kile
      unstable.river
      brightnessctl
      gnome3.adwaita-icon-theme # Icons for gnome packages that sometimes use them but don't depend on them
      gnome3.nautilus
      gnome3.nautilus-python
      gnome3.sushi
      breeze-qt5 # For them sweet cursors
    ];
    services = {
      xserver = {
        enable = true;
	displayManager = {
	  defaultSession = "river";
	  session = [
            {
	      manage = "desktop";
	      name = "river";
	      start = ''
		systemd-cat -t river -- ${pkgs.unstable.river}/bin/river &
		waitPID=$!
	      '';
	    }
	  ];
	};
      };
	greetd.settings = {
	  default_session.command = "${pkgs.greetd.tuigreet}/bin/tuigreet --cmd ${pkgs.unstable.river}/bin/river";
        };
    }; 

    home.configFile = {
      "river/init" = {
	text = '' 
#!/bin/sh
mod="Mod4"

riverctl map normal $mod Return spawn alacritty

riverctl map normal $mod W spawn firefox
# Mod+Q to close the focused view
riverctl map normal $mod Q close

# Mod+E to exit river
riverctl map normal $mod E exit
	'';
      };
    };
    programs.xwayland.enable = true;

    home-manager.users.${config.user.name} = {
      programs.mako = {
	enable = true;
        anchor = "top-center";
      };
    };
  };
}
