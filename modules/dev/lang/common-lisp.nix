# modules/dev/common-lisp.nix --- https://common-lisp.net/
#
# Mostly for my stumpwm config, and the occasional dip into lisp gamedev.

{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.dev.lang.common-lisp;
in {
  options.modules.dev.lang.common-lisp = {
    enable = mkBoolOpt false;
    vscodeExt = mkOption {
      type = types.listOf types.package;
      description = "List of vscode extensions to enable";
      default = (with pkgs.vscode-extensions; [ ailisp.commonlisp-vscode ]);
    };
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [ sbcl lispPackages.quicklisp ];
  };
}
