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

  # For persistence
  inherit (config.home) homeDirectory username;
  startWithHome = xdgDir:
    if (builtins.substring 0 5 xdgDir) == "$HOME" then true else false;
  relToHome = xdgDir:
    if (startWithHome xdgDir) then
      (builtins.substring 6 (builtins.stringLength xdgDir) xdgDir)
    else
      (builtins.substring (builtins.stringLength homeDirectory)
        (builtins.stringLength xdgDir)
        xdgDir);
  data =
    if config.xdg.enable then
      (relToHome config.xdg.dataHome)
    else
      ".local/share";

  langPackages = with pkgs; [
    go
    gopls
    gofumpt
    go-tools
    dep
  ];

  shellAliases = {
    gob = "go build";
    goc = "go clean";
    god = "go doc";
    gof = "go fmt";
    gofa = "go fmt ./...";
    gog = "go get";
    goi = "go install";
    gol = "go list";
    gom = "go mod";
    gop = "cd $GOPATH";
    gopb = "cd $GOPATH/bin";
    gops = "cd $GOPATH/src";
    gor = "go run";
    got = "go test";
    gov = "go vet";
  };

  langVars = {
    GO111MODULE = "auto";
    GOBIN = "$XDG_BIN_HOME";
    GOPATH = "$XDG_DATA_HOME/go";
    PATH = [ "$GOPATH/bin" ];
  };


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
      default = shellAliases;
      description = ''
        An attribute set that maps aliases for ${currLang} programming.
      '';
    };
    sessionVariables = mkOption {
      type = types.attrs;
      default = langVars;
      example = { CCACHE_DIR = "$XDG_CACHE_HOME/ccache"; };
      description = ''
        Environment variables to always set at login for ${currLang} programming.
        </para><para>
      '';
    };
  };
  config = mkIf enabled {
    home = {
      persistence."/persist/${homeDirectory}".directories =
        mkIf (config.home.persistence."/persist/${homeDirectory}".allowOther) [
          "${data}/go"
        ];
      packages = config.${pLang}.packages;
      sessionVariables = config.${pLang}.sessionVariables;
    };
    programs.zsh.shellAliases = mkIf ifZsh config.${pLang}.shellAliases;
  };
}
