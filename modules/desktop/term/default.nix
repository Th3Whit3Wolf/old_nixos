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
      jq.enable = true;
    };
  };
}