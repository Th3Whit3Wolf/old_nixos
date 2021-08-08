{ config, lib, pkgs, ... }:

with lib;
let
  inherit (lib) fileContents mkAfter;
  inherit (lib.our) mkFirefoxUserJs;
  inherit (config.home) homeDirectory username;

  firefoxUserSettings = import ./settings.nix { downloadDir = "${homeDirectory}/Downs"; };
  mozPath = ".mozilla";
  cfgPath = "${mozPath}/firefox";

  configCss = builtins.readFile ./config.css;
  treeStyleTabCss = builtins.readFile ./tree-style-tab.css;
  chrome = pkgs.flyingfox.override { inherit configCss treeStyleTabCss; };

  ryceeAddons = with pkgs.nur.repos.rycee.firefox-addons; [
    #auto-tab-discard
    bitwarden
    canvasblocker
    clearurls
    darkreader
    fraidycat
    i-dont-care-about-cookies
    lastpass-password-manager
    netflix-1080p
    octotree
    refined-github
    multi-account-containers
    #sidebery
    temporary-containers
    terms-of-service-didnt-read
    tree-style-tab
    ublock-origin
    unpaywall
  ];

  extensionsEnvPkg = pkgs.buildEnv {
    name = "hm-firefox-extensions";
    paths = ryceeAddons;
  };
  extensionPath = "extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}";

in


{
  home = {
    packages = [ pkgs.firefox-wayland ];
    file = {
      "${cfgPath}/profiles.ini".text = ''
        [General]
        StartWithLastProfile=1

        [Profile0]
        Default=1
        IsRelative=1
        Name=doc
        Path=doc
      '';

      "${cfgPath}/doc/user.js" = {
        text = mkFirefoxUserJs {
          firefoxConfig = firefoxUserSettings;
        };
      };

      "${cfgPath}/doc/chrome" = {
        source = "${chrome}/chrome";
        recursive = true;
      };
      "${cfgPath}/doc/extensions" = {
        source = "${extensionsEnvPkg}/share/mozilla/${extensionPath}";
        recursive = true;
        force = true;
      };
    };
  };
}
