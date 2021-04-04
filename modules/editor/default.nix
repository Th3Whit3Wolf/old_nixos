{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.editor;
in {
  options.modules.editor = { default = mkOpt types.str "nvim"; };

  config = mkIf (cfg.default != null) { env.EDITOR = cfg.default; };
}
