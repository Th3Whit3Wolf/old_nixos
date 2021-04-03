{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.editors.nvim;
  lang = config.modules.dev.lang;
  vcs  = config.modules.dev.vcs;

  useGit        = vcs.git.enable;
  useCC         = lang.cc.enable;
  useClojure    = lang.clojure.enable;
  useCommonLisp = lang.cc.enable;
  useGo         = lang.go.enable;
  useLua        = lang.lua.enable;
  useNix        = lang.nix.enable;
  useNode       = lang.node.enable;
  usePython     = lang.python.enable;
  useRuby       = lang.ruby.enable;
  useRust       = lang.rust.enable;
  useScala      = lang.scala.enable;
  useShell      = lang.shell.enable;

  clojurePlugins = if useClojure      then lang.clojure.neovimPlugins else [ ];
  goPlugins      = if useGo           then lang.go.neovimPlugins else [ ];
  nixPlugins     = if useNix          then lang.nix.neovimPlugins else [ ];
  nodePlugins    = if useNode         then lang.node.neovimPlugins else [ ];
  rubyPlugins    = if useRuby         then lang.ruby.neovimPlugins else [ ];
  rustPlugins    = if useRust         then lang.rust.neovimPlugins else [ ];
  scalaPlugins   = if useScala        then lang.scala.neovimPlugins else [ ];

  ## Helpful for creating vim plugin overlay
  # https://nixos.wiki/wiki/Vim
  # https://github.com/NixOS/nixpkgs/blob/98686d3b7f9bf156331b88c2a543da224a63e0e2/pkgs/misc/vim-plugins/overrides.nix
  # https://github.com/NixOS/nixpkgs/blob/master/pkgs/misc/vim-plugins/generated.nix
  # https://github.com/NixOS/nixpkgs/blob/master/pkgs/misc/vim-plugins/overrides.nix
  defaultPlugins = with pkgs.vimPlugins; [
    { plugin = vim-easy-align;                   } 
    { plugin = vim-which-key;                    }
    { plugin = vista-vim; optional = true;       }
    { plugin = vim-closetag; optional = true;    }
    { plugin = nvim-treesitter; optional = true; }
    { plugin = vim-yaml; optional = true;        }
  ];
in {
  options.modules.editors.nvim = { enable = mkBoolOpt false; };

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
      plugins = defaultPlugins 
             ++ clojurePlugins
             ++      goPlugins 
	     ++     nixPlugins
	     ++    nodePlugins
	     ++    rubyPlugins 
	     ++    rustPlugins
	     ++   scalaPlugins;
      withPython3 = true;
      withNodeJs = true;
    };

    environment.shellAliases = {
      suvim = "sudo -E nvim";
      vim = "nvim";
      suvi = "sudo -E nvim";
      vi = "nvim";
      suv = "sudo -E nvim";
      v = "nvim";
    };
  };
}
