{ config, options, lib, pkgs, ... }:

with lib;
with builtins;

let
  currLang = baseNameOf (builtins.toString ./.);
  enabled = elem currLang polyglot.langs || elem "all" polyglot.langs;
  polyglot = config.home.nix-polyglot;
  pLang = "home.nix-polyglot.lang.${currLang}";
  ifZsh = polyglot.enableZshIntegration;

  imports = [
    ./vscode.nix
    #./neovim.nix
  ];

  langPackages = with pkgs; [
    luajit
    luajitPackages.luarocks
    luajitPackages.moonscript
    luajitPackages.busted
    sumneko-lua-language-server
  ];
in
{
  inherit imports;
  options.${pLang} = {
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
    shellAliases = mkOption {
      type = types.attrsOf types.str;
      default = { };
      description = ''
        An attribute set that maps aliases for ${currLang} programming.
      '';
    };
    sessionVariables = mkOption {
      type = types.attrs;
      default = { };
      example = { CCACHE_DIR = "$XDG_CACHE_HOME/ccache"; };
      description = ''
        Environment variables to always set at login for ${currLang} programming.
        </para><para>
      '';
    };
  };
  config = mkIf enabled {
    home = {
      packages = config.${pLang}.packages;
      sessionVariables = config.${pLang}.sessionVariables;
    };
    programs.zsh.shellAliases = mkIf ifZsh config.${pLang}.shellAliases;
  };
}

