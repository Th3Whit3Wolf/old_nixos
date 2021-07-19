{ config, options, lib, pkgs, ... }:

with lib;
with builtins;

let
  currLang = baseNameOf (builtins.toString ./.);
  enabled = elem currLang polyglot.langs || elem "all" polyglot.langs;
  polyglot = config.nix-polyglot;
  cfg = polyglot.lang.${currLang};

  imports = [
    ./vscode.nix
    ./neovim.nix
  ];

  langPackages = with pkgs; [
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
in
{
  inherit imports;
  options.nix-polyglot.lang.${currLang} = {
    enable = mkOption {
      type = types.bool;
      default = enabled;
      description = "Whether to enable nix-polyglot's rust support.";
    };
    packages = mkOption {
      type = types.listOf types.package;
      default = langPackages;
      description = ''
        List of packages to install for rust development.
      '';
    };
  };
  config = mkIf enabled {
    home = {
      sessionVariables = {
        CCACHE_DIR = "$XDG_CACHE_HOME/ccache";
        CCACHE_CONFIGPATH = "$XDG_CONFIG_HOME/ccache.config";
      };
      packages = cfg.packages;
    };
  }
