{ inputs, config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.editor.nvim;
  configDir = config.dotfiles.configDir;
  lang = config.modules.dev.lang;
  vcs = config.modules.dev.vcs;

  useGit = vcs.git.enable;
  useCC = lang.cc.enable;
  useClojure = lang.clojure.enable;
  useCommonLisp = lang.cc.enable;
  useGo = lang.go.enable;
  useLua = lang.lua.enable;
  useNix = lang.nix.enable;
  useNode = lang.node.enable;
  usePython = lang.python.enable;
  useRuby = lang.ruby.enable;
  useRust = lang.rust.enable;
  useScala = lang.scala.enable;
  useShell = lang.shell.enable;

  clojurePlugins = if useClojure then lang.clojure.neovimPlugins else [ ];
  goPlugins = if useGo then lang.go.neovimPlugins else [ ];
  nixPlugins = if useNix then lang.nix.neovimPlugins else [ ];
  nodePlugins = if useNode then lang.node.neovimPlugins else [ ];
  rubyPlugins = if useRuby then lang.ruby.neovimPlugins else [ ];
  rustPlugins = if useRust then lang.rust.neovimPlugins else [ ];
  scalaPlugins = if useScala then lang.scala.neovimPlugins else [ ];

  ## Helpful for creating vim plugin overlay
  # https://nixos.wiki/wiki/Vim
  # https://github.com/NixOS/nixpkgs/blob/98686d3b7f9bf156331b88c2a543da224a63e0e2/pkgs/misc/vim-plugins/overrides.nix
  # https://github.com/NixOS/nixpkgs/blob/master/pkgs/misc/vim-plugins/generated.nix
  # https://github.com/NixOS/nixpkgs/blob/master/pkgs/misc/vim-plugins/overrides.nix
  defaultPlugins = with pkgs.vimPlugins; [
    { plugin = vim-easy-align; }
    { plugin = vim-which-key; }
    {
      plugin = vista-vim;
      optional = true;
    }
    {
      plugin = vim-closetag;
      optional = true;
    }
    {
      plugin = nvim-treesitter;
      optional = true;
    }
    {
      plugin = vim-yaml;
      optional = true;
    }
  ];
in {
  options.modules.editor.nvim = {
    enable = mkBoolOpt false;
    zsh_plugin_text = mkOption {
      type = types.lines;
      description = "How to source necessary zsh plugins";
      default = ''
                # Open lazygit commit window inside neovim
                if [ -n "$NVIM_LISTEN_ADDRESS" ]; then
                  alias nvim="nvr -cc split --remote-wait +'set bufhidden=wipe'"
                  alias vim="nvr -cc split --remote-wait +'set bufhidden=wipe'"
                  alias vi="nvr -cc split --remote-wait +'set bufhidden=wipe'"
                  alias v="nvr -cc split --remote-wait +'set bufhidden=wipe'"
                else
                  alias vim="nvim"
                  alias vi="nvim"
                  alias v="nvim"
        	fi

                if [ -n "$NVIM_LISTEN_ADDRESS" ]; then
                    export VISUAL="nvr -cc split --remote-wait +'set bufhidden=wipe'"
                    export EDITOR="nvr -cc split --remote-wait +'set bufhidden=wipe'"
                else
                    export VISUAL="nvim"
                    export EDITOR="nvim"
                fi

        	alias suvim="sudo -E nvim"
        	alias suvi="sudo -E nvim"
        	alias suv="sudo -E nvim"
              '';
    };
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      editorconfig-core-c
      neovim-nightly
      neovim-remote
      nodePackages.vim-language-server
      nodePackages.vscode-json-languageserver-bin
      nodePackages.vscode-html-languageserver-bin
      nodePackages.vscode-css-languageserver-bin
      tree-sitter
    ];

    environment.systemPackages = [ pkgs.unstable.neovim ];

    home-manager.users.${config.user.name}.programs.neovim = {
      enable = true;
      package = pkgs.neovim-nightly;
      plugins = defaultPlugins ++ clojurePlugins ++ goPlugins ++ nixPlugins
        ++ nodePlugins ++ rubyPlugins ++ rustPlugins ++ scalaPlugins;
      withPython3 = true;
      withNodeJs = true;
    };
    home.dataFile."nvim/site/ftdetect/ftdetect.vim".source =
      "${configDir}/term/nvimData/ftdetect/ftdetect.vim";
  };
}
