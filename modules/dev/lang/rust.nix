# modules/dev/rust.nix --- https://rust-lang.org
#
# Oh Rust. The light of my life, fire of my loins. Years of C++ has conditioned
# me to believe there was no hope left, but the gods have heard us. Sure, you're
# not going to replace C/C++. Sure, your starlight popularity has been
# overblown. Sure, macros aren't namespaced, cargo bypasses crates.io, and there
# is no formal proof of your claims for safety, but who said you have to solve
# all the world's problems to be wonderful?

{ inputs, config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.dev.lang.rust;
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
  options.modules.dev.lang.rust = {
    enable = mkBoolOpt false;
    neovimPlugins  = mkOption {
      type = with types; listOf (either package pluginWithConfigType);
      default = [  
        { plugin = pkgs.vimPlugins.rust-vim;  optional = true;} 
        { plugin = pkgs.vimPlugins.vim-crates; optional = true;} 
	# "nastevens/vim-cargo-make"
	# nastevens/vim-duckscrip
	# "ron-rs/ron.vim",
      ];
    };
    vscode = {
      ext = mkOption {
        type = types.listOf types.package;
        description = "List of vscode extensions to enable";
        default = (with pkgs.vscode-extensions; [
          matklad.rust-analyzer
          serayuzgur.crates
          belfz.search-crates-io
          a5huynh.vscode-ron
        ]);
      };
      settings = mkOption {
        type = jsonFormat.type;
        description = ''
          Configuration written to Visual Studio Code's
          <filename>settings.json</filename>.
        '';
        default = {
          "rust-analyzer" = {
            "checkOnSave.command" = "clippy";
            "procMacro.enable" = true;
          };
        };
      };
    };
    zsh_plugin_text = mkOption {
      type = types.lines;
      description = "How to source necessary zsh plugins";
      default = ''
        # Cargo Completions
        path+="${inputs.zsh-completion-cargo}"
        fpath+="${inputs.zsh-completion-cargo}"
        #source ${inputs.zsh-completion-cargo}/rustup.plugin.zsh

        # Rustup Completions
        path+="${inputs.zsh-completion-rustup}"
        fpath+="${inputs.zsh-completion-rustup}"
        #source ${inputs.zsh-completion-rustup}/rustup.plugin.zsh
      '';
    };
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      cargo
      cargo-deb
      cargo-asm
      cargo-wipe
      cargo-make
      cargo-kcov
      cargo-fuzz
      cargo-fund
      cargo-edit
      cargo-deny
      cargo-udeps
      cargo-embed
      cargo-cross
      cargo-bloat
      cargo-audit
      cargo-about
      cargo-update
      cargo-readme
      cargo-geiger
      cargo-expand
      cargo-inspect
      cargo-generate
      cargo-release
      cargo-tarpaulin
      cargo-whatfeatures
      clippy
      git-ignore
      licensor
      microserver
      rust-analyzer
      rustc
      rustfmt
      systemfd
      # unstable.trunk
      wabt
      wasm-pack
      wasm-strip
      wasm-bindgen-cli
      wasmer
      wasmtime
    ];

    # See https://discourse.nixos.org/t/rust-src-not-found-and-other-misadventures-of-developing-rust-on-nixos/11570/3?u=samuela.
    env.RUST_SRC_PATH = "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";
    env.RUSTUP_HOME = "$XDG_DATA_HOME/rustup";
    env.CARGO_HOME = "$XDG_DATA_HOME/cargo";
    env.PATH = [ "$CARGO_HOME/bin" ];

    environment.shellAliases = {
      rsc = "rustc";
      rup = "rustup";
      ca = "cargo";
    };
  };
}
