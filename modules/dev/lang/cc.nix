# modules/dev/cc.nix --- C & C++
#
# I love C. I tolerate C++. I adore C with a few choice C++ features tacked on.
# Liking C/C++ seems to be an unpopular opinion. It's my guilty secret, so don't
# tell anyone pls.

{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.dev.lang.cc;
in {
  options.modules.dev.lang.cc = {
    enable = mkBoolOpt false;
    vscodeExt = mkOption {
      type = types.listOf types.package;
      description = "List of vscode extensions to enable";
      default = (with pkgs.vscode-extensions; [
        ms-vscode.cpptools
        llvm-org.lldb-vscode
        ccls-project.ccls
      ]);
    };
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      clang
      gcc
      musl
      #      bear
      gdb
      cmake
      cmake-language-server
      llvmPackages.libcxx
      ccls
      ccache
      fmt
    ];
    env.CCACHE_DIR = "$XDG_CACHE_HOME/ccache";
    env.CCACHE_CONFIGPATH = "$XDG_CONFIG_HOME/ccache.config";
  };
}
