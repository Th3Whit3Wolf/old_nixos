# modules/dev/node.nix --- https://nodejs.org/en/
#
# JS is one of those "when it's good, it's alright, when it's bad, it's a
# disaster" languages.

{ inputs, config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let 
  cfg = config.modules.dev.lang.node;
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
  options.modules.dev.lang.node = {
    enable = mkBoolOpt false;
    neovimPlugins  = mkOption {
      type = with types; listOf (either package pluginWithConfigType);
      default = [
        { plugin = pkgs.vimPlugins.coffeeScript;   optional = true;}
        { plugin = pkgs.vimPlugins.vim-closetag;   optional = true;}
        { plugin = pkgs.vimPlugins.purescript-vim; optional = true;}
        { plugin = pkgs.vimPlugins.vim-pug;        optional = true;}

	# turbio/bracey.vim
	# sheerun/vim-haml
	# mustache/vim-mustache-handlebars
	# hhsnopek/vim-sugarss
	# cakebaker/scss-syntax.vim
      ];
    };
    vscodeExt = mkOption {
      type = types.listOf types.package;
      description = "List of vscode extensions to enable";
      default = (with pkgs.vscode-extensions; [
        dzhavat.css-initial-value
        esbenp.prettier-vscode
        humao.rest-client
        zignd.html-css-class-completion
        msjsdiag.vscode-react-native
        dbaeumer.vscode-eslint
        svelte.svelte-vscode
        formulahendry.auto-close-tag
        auchenberg.vscode-browser-preview
        ritwickdey.LiveServer
        xabikos.JavaScriptSnippets
        WallabyJs.quokka-vscode
        ritwickdey.live-sass
        dsznajder.es7-react-js-snippets
        denoland.vscode-deno
        stylelint.vscode-stylelint
        christian-kohler.npm-intellisense
        DominicVonk.parameter-hints
        formulahendry.auto-rename-tag
        HookyQR.beautify
        yatki.vscode-surround
        steoates.autoimport
        vincaslt.highlight-matching-tag
        jock.svg
        cssho.vscode-svgviewer
      ]);
    };
    zsh_plugin_text = mkOption {
      type = types.lines;
      description = "How to source necessary zsh plugins";
      default = ''
        # NPM Completions
        path+="${inputs.zsh-completion-npm}"
        fpath+="${inputs.zsh-completion-npm}"
        source ${inputs.zsh-completion-npm}/zsh-better-npm-completion.plugin.zsh

        # Yarn Completions
        path+="${inputs.zsh-completion-yarn}"
        fpath+="${inputs.zsh-completion-yarn}"
        source ${inputs.zsh-completion-yarn}/yarn-autocompletions.plugin.zsh
              '';
    };
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      nodejs
      yarn
      deno
      nodePackages.purescript-language-server
      nodePackages.typescript-language-server
      elmPackages.elm-language-server
      nodePackages.vue-language-server
      nodePackages.javascript-typescript-langserver
      nodePackages.vscode-css-languageserver-bin
    ];

    env.NPM_CONFIG_USERCONFIG = "$XDG_CONFIG_HOME/npm/config";
    env.NPM_CONFIG_CACHE = "$XDG_CACHE_HOME/npm";
    env.NPM_CONFIG_TMP = "$XDG_RUNTIME_DIR/npm";
    env.NPM_CONFIG_PREFIX = "$XDG_CACHE_HOME/npm";
    env.NVM_DIR = "$XDG_DATA_HOME/nvm";
    env.NODE_REPL_HISTORY = "$XDG_CACHE_HOME/node/repl_history";
    env.PATH = [ "$(${pkgs.yarn}/bin/yarn global bin)" ];

    # Run locally installed bin-script, e.g. n coffee file.coffee
    environment.shellAliases = {
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

    home.configFile."npm/config".text = ''
      cache=$XDG_CACHE_HOME/npm
      prefix=$XDG_DATA_HOME/npm
      tmp=$XDG_RUNTIME_DIR/npm
      init-module=$XDG_CONFIG_HOME/npm/config/npm-init.js
    '';
  };
}
