{ config, lib, pkgs, ... }:

with lib;
with builtins;

let
    currLang = baseNameOf (builtins.toString ./.);
    enabled = elem currLang polyglot.langs || elem "all" polyglot.langs;
    polyglot = config.nix-polyglot;
    cfg = polyglot.lang.rust;

    ## Need to get https://github.com/MenkeTechnologies/zsh-cargo-completion

    rust-stable = pkgs.rust-bin.stable.latest.default.override {
        extensions = [ 
            "cargo"
            "clippy"
            "rust-docs"
            "rust-src"
            "rust-std"
            "rustc"
            "rustfmt"
        ];
        targets = [ 
            "x86_64-unknown-linux-gnu"
            "x86_64-unknown-linux-musl"
            "wasm32-unknown-unknown"
            "wasm32-wasi"
        ];
    };

    langPackages = with pkgs; [
        cargo-about
        cargo-asm
        cargo-audit
        cargo-bloat
        cargo-cross
        cargo-deb
        cargo-deny
        cargo-edit
        cargo-embed
        cargo-expand
        cargo-fund
        cargo-fuzz
        cargo-geiger
        cargo-generate
        cargo-inspect
        cargo-kcov
        cargo-make
        cargo-readme
        cargo-release
        cargo-tarpaulin
        cargo-udeps
        cargo-update
        cargo-whatfeatures
        cargo-wipe
        gcc # rust unable to find cc linker if this is not installed
        microserver
        rust-analyzer
        rust-stable
        systemfd
        trunk
        wasm-bindgen-cli
        wasm-pack
        wasm-strip
        wasmer
        wasmtime
    ];

    shellAliases = {
        cr = "cargo run";
        ccl = "cargo clean";
        ccy = "cargo clippy";
        cb = "cargo build --release";
        ct = "cargo test";
        cad = "cargo add";
        ci = "cargo install";
        cfi = "cargo fix";
        cfm = "cargo fmt";
        cfe = "cargo fetch";
        cpa = "cargo package";
        cs = "cargo search";
        cfa = "cargo fmt; cargo fix --allow-dirty --allow-staged";
    };

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

    vscodeExtensions = with pkgs.vscode-extensions; [
        a5huynh.vscode-ron
        serayuzgur.crates
        matklad.rust-analyzer
        # belfz.search-crates-io
    ];

    vscodeSettings = {
        rust-analyzer = {
            cargo.allFeatures = true;
            checkOnSave.command = "clippy";
            procMacro.enable = true;
            rustcSource = "${pkgs.rust-analyzer}";
        };
    };
in 

{
    options.nix-polyglot.lang.rust = {
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
                RUST_SRC_PATH = "${rust-stable}/lib/rustlib/src/rust/library/";
            };
            packages = cfg.packages;
        };
        programs.ZSH = {
            shellAliases = mkIf polyglot.enableZshIntegration shellAliases;
            pathVar = ["$CARGO_HOME/bin"];
            sessionVariables = {
                RUSTUP_HOME = "$XDG_DATA_HOME/rustup";
                CARGO_HOME = "$XDG_DATA_HOME/cargo";
            };
            sitefunctions = [
                {
                name = "cargo";
                src = ./zsh/cargo;
                }
            ];
        };
        nix-polyglot = {
            neovim = {
                plugins = neovimPlugins;
            };
            vscode = {
                userSettings = vscodeSettings;
                extensions = vscodeExtensions;
            };
        };
    };
}