{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.desktop.term;
  configDir = config.dotfiles.configDir;
  isX11 = config.modules.desktop.term.st.enable;
in {
  options.modules.desktop.term = { default = mkOpt types.str "xterm"; };

  config = {
    services.xserver.desktopManager.xterm.enable =
      mkIf isX11 (mkDefault (cfg.default == "xterm"));

    env.TERMINAL = mkIf isX11 cfg.default;

    home-manager.users.${config.user.name}.programs = {
      bat = {
        enable = true;
        config = { theme = "TwoDark"; };
      };
      jq.enable = true;
    };
    home.configFile = {
      "bottom/bottom.toml" = {
        source = "${configDir}/term/bottom/space_dark.toml";
      };
      "wofi" = {
        source = "${configDir}/term/wofi";
        recursive = true;
      };
      "gitui/theme.ron" = {
        source = "${configDir}/term/gitui/space_dark.ron";
      };
      "gitui/key_config.ron" = {
        source = "${configDir}/term/gitui/key_config.ron";
      };
      "procs/config.toml" = { source = "${configDir}/term/procs/config.toml"; };
    };
  };
}
