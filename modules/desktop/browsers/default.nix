{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.desktop.browsers;
  hasFireFox = config.modules.desktop.browsers.firefox.enable;
  hasBrave = config.modules.desktop.browsers.brave.enable;
  hasQTBrowser = config.modules.desktop.browsers.qutebrowser.enable;
  hasBrowser =
    ((hasFireFox || hasBrave || hasQTBrowser) && cfg.default != null);
in {
  options.modules.desktop.browsers = {
    default = mkOpt (with types; nullOr str) null;
  };

  config = mkIf hasBrowser {
    env.BROWSER = cfg.default;

    home-manager.users.${config.user.name}.xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        "text/html" = [ "${cfg.default}.desktop" ];
        "x-scheme-handler/http" = [ "${cfg.default}.desktop" ];
        "x-scheme-handler/https" = [ "${cfg.default}.desktop" ];
        "x-scheme-handler/about" = [ "${cfg.default}.desktop" ];
        "x-scheme-handler/unknown" = [ "${cfg.default}.desktop" ];
      };
    };

    #environment.systemPackages = [pkgs.profile-sync-daemon];
    #services.psd = {
    #enable = true;
    #browser = [
    #  (if hasFireFox then "firefox" else "")
    #  (if hasBrave then "brave" else "")
    #  (if hasQTBrowser then "qutebrowser" else "")
    #];
    #users = [ "${config.user.name}" ];
    #};
  };
}
