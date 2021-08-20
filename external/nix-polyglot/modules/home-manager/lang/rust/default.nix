{ config, options, lib, pkgs, ... }:

with lib;
with builtins;


let
  inherit (config.home) homeDirectory;
  relToData = dir: if config.xdg.enable then "${config.xdg.dataHome}/${dir}" else "${homeDirectory}/.local/share/${dir}";

  currLang = baseNameOf (builtins.toString ./.);
  enabled = elem currLang polyglot.langs || elem "all" polyglot.langs;
  polyglot = config.home.nix-polyglot;
  pLang = "home.nix-polyglot.lang.${currLang}";
  ifZsh = polyglot.enableZshIntegration;

  imports = [
    ./vscode.nix
    ./neovim.nix
  ];

  rust-stable = pkgs.rust-bin.stable.latest.default.override {
    extensions =
      [ "cargo" "clippy" "rust-docs" "rust-src" "rust-std" "rustc" "rustfmt" ];
    targets = [
      "x86_64-unknown-linux-gnu"
      "x86_64-unknown-linux-musl"
      "wasm32-unknown-unknown"
      "wasm32-wasi"
    ];
  };

  langPackages = with pkgs; [
    clang
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
    #gcc # rust unable to find cc linker if this is not installed
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

  langVars = {
    RUSTUP_HOME = (relToData "rustup");
    CARGO_HOME = (relToData "cargo");
    RUST_SRC_PATH = "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";
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
      packages = config.${pLang}.packages;
      sessionPath = [ "${relToData "cargo/bin"}" ];
      sessionVariables = config.${pLang}.sessionVariables;
    };
    programs.zsh = {
      shellAliases = mkIf ifZsh config.${pLang}.shellAliases;
      shellGlobalAliases = langVars;
    };
  };
}
