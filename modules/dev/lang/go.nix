{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.dev.lang.go;
  jsonFormat = pkgs.formats.json { };
  pluginWithConfigType = types.submodule {
    options = {
      config = mkOption {
        type = types.lines;
        description = "vimscript for this plugin to be placed in init.vim";
        default = "";
      };

      optional = mkEnableOption "optional" // {
        description = "Don't load by default (load with :packadd)";
      };

      plugin = mkOption {
        type = types.package;
        description = "vim plugin";
      };
    };
  };
in {
  options.modules.dev.lang.go = {
    enable = mkBoolOpt false;
    neovimPlugins  = mkOption {
      type = with types; listOf (either package pluginWithConfigType);
      default = [
        { plugin = pkgs.vimPlugins.vim-go; optional = true;}
      ];
    };
    vscode = {
      ext = mkOption {
        type = types.listOf types.package;
        description = "List of vscode extensions to enable";
        default = (with pkgs.vscode-extensions; [ golang.Go ]);
      };
      settings = mkOption {
        type = jsonFormat.type;
        description = ''
          Configuration written to Visual Studio Code's
          <filename>settings.json</filename>.
        '';
        default = {
          "go" = {
            "autocompleteUnimportedPackages" = true;
            "formatTool" = "gofumpt";
            "gocodeAutoBuild" = true;
            "languageServerExperimentalFeatures" = { "diagnostics" = true; };
          };
        };
      };
    };
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [ go gopls gofumpt dep ];

    env.GOBIN = "$XDG_BIN_HOME";
    env.GOPATH = "$XDG_DATA_HOME/go";
    env.PATH = [ "$GOPATH" ];

    environment.shellAliases = {
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
  };
}
