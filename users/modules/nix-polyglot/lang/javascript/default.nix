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
    #./neovim.nix
  ];

  langPackages = with pkgs; [
    nodejs
    yarn
    deno
    nodePackages.purescript-language-server
    nodePackages.typescript-language-server
    nodePackages.typescript
    elmPackages.elm-language-server
    nodePackages.vue-language-server
    nodePackages.javascript-typescript-langserver
    nodePackages.eslint
    nodePackages.prettier

    # Task Runners
    nodePackages.grunt-cli
    nodePackages.gulp
    nodePackages.jake

    # Bundlers
    nodePackages.webpack
    nodePackages.browserify
    nodePackages.rollup
    nodePackages.parcel-bundler

    #SWC


    postman
  ];

  shellAliases = {
    n = ''PATH="$(${pkgs.nodejs}/bin/npm bin):$PATH"'';
    y = "yarn";
    ya = "yarn add";
    yad = "yarn add --dev";
    yap = "yarn add --peer";
    yb = "yarn build";
    ycc = "yarn cache clean";
    yga = "yarn global add";
    ygls = "yarn global list";
    ygrm = "yarn global remove";
    ygu = "yarn global upgrade";
    yh = "yarn help";
    yi = "yarn init";
    yin = "yarn install";
    yls = "yarn list";
    yout = "yarn outdated";
    yp = "yarn pack";
    yrm = "yarn remove";
    yrun = "yarn run";
    ys = "yarn serve";
    yst = "yarn start";
    yt = "yarn test";
    yuc = "yarn global upgrade && yarn cache clean";
    yui = "yarn upgrade-interactive";
    yup = "yarn upgrade";
  };

  langVars = {
    NPM_CONFIG_USERCONFIG = "$XDG_CONFIG_HOME/npm/config";
    NPM_CONFIG_CACHE = "$XDG_CACHE_HOME/npm";
    NPM_CONFIG_TMP = "$XDG_RUNTIME_DIR/npm";
    NPM_CONFIG_PREFIX = "$XDG_CACHE_HOME/npm";
    NODE_REPL_HISTORY = "$XDG_CACHE_HOME/node/repl_history";
    NVM_DIR = "$XDG_DATA_HOME/nvm";
  };
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
    xdg.configFile."npm/config".text = ''
      cache=$XDG_CACHE_HOME/npm
      prefix=$XDG_DATA_HOME/npm
      tmp=$XDG_RUNTIME_DIR/npm
      init-module=$XDG_CONFIG_HOME/npm/config/npm-init.js
    '';
    programs.ZSH.pathVar = [ "$(${pkgs.yarn}/bin/yarn global bin)" ];

  };
}
