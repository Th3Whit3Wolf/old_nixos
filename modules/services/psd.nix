{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let 
  cfg = config.modules.services.psd;
  browsers = config.modules.desktop.browsers;
in {
  options.modules.services.psd = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    services.psd.enable = true;
    user.packages = [ pkgs.fuse-overlayfs pkgs.profile-sync-daemon ];
    home-manager.users.${config.user.name}.xdg.configFile."psd/psd.conf".text = '' 
      USE_OVERLAYFS="yes"
      USE_SUSPSYNC="no"

      # this array is left commented.
      #
      # Possible values:
      #  chromium
      #  chromium-dev
      #  conkeror.mozdev.org
      #  epiphany
      #  falkon
      #  firefox
      #  firefox-trunk
      #  google-chrome
      #  google-chrome-beta
      #  google-chrome-unstable
      #  heftig-aurora
      #  icecat
      #  inox
      #  luakit
      #  midori
      #  opera
      #  opera-beta
      #  opera-developer
      #  opera-legacy
      #  otter-browser
      #  qupzilla
      #  qutebrowser
      #  palemoon
      #  rekonq
      #  seamonkey
      #  surf
      #  vivaldi
      #  vivaldi-snapshot
      BROWSERS=(${optionalString (browsers.firefox.enable) ''firefox''})
    '';
  };
}
