{ config, lib, pkgs, ... }:

with lib;
let
  inherit (lib) fileContents mkAfter;
  inherit (lib.our) mkFirefoxUserJs;
  inherit (config.home) homeDirectory username;

  extensionsList = [
    "@testpilot-containers"
    "CanvasBlocker@kkapsner.de"
    "addon@darkreader.org"
    "jid0-3GUEt1r69sQNSrca5p8kx9Ezc3U@jetpack"
    "jid1-KKzOGWgsW3Ao4Q@jetpack"
    "screenshots@mozilla.org"
    "treestyletab@piro.sakura.ne.jp"
    "uBlock0@raymondhill.net"
    "{446900e4-71c2-419f-a6a7-df9c091e268b}"
    "{74145f27-f039-47ce-a470-a662b129930a}"
    "{94060031-effe-4b93-89b4-9cd570217a8d}"
    "{a4c4eda4-fb84-4a84-b4a1-f7c1cbf2a1ad}"
    "{c607c8df-14a7-4f28-894f-29e8722976af}"
  ];

  firefoxExtensionSettings = builtins.listToAttrs (forEach extensionsList
    (x:
      nameValuePair "extensions.webextensions.ExtensionStorageIDB.migrated.${x}" true
    ) ++ [
    { name = "devtools.storage.extensionStorage.enabled"; value = true; }
    { name = "extensions.webextensions.ExtensionStorageIDB.enabled"; value = true; }
  ]);
  firefoxUserSettings = (import ./settings.nix { downloadDir = "${homeDirectory}/Downs"; }) // firefoxExtensionSettings;
  mozPath = ".mozilla";
  cfgPath = "${mozPath}/firefox";

  configCss = fileContents ./config.css;
  treeStyleTabCss = fileContents ./tree-style-tab.css;
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

  wayFirefox = pkgs.wrapFirefox pkgs.firefox-unwrapped {
    forceWayland = true;
    extraPolicies = {
      ExtensionSettings = { };
    };
  };
in


{
  home = {
    packages = [ wayFirefox ];
    file = {
      "${cfgPath}/profiles.ini".text = ''
        [General]
        StartWithLastProfile=1

        [Profile0]
        Default=1
        IsRelative=1
        Name=${username}
        Path=${username}
      '';

      "${cfgPath}/${username}/user.js" = {
        text = mkFirefoxUserJs {
          firefoxConfig = firefoxUserSettings;
        };
      };

      "${cfgPath}/${username}/chrome" = {
        source = "${chrome}/chrome";
        recursive = true;
      };

      "${cfgPath}/${username}/extensions" = {
        source = "${extensionsEnvPkg}/share/mozilla/${extensionPath}";
        recursive = true;
        force = true;
      };
    };
    sessionVariables.MOZ_ENABLE_WAYLAND = 1;
  };
}
