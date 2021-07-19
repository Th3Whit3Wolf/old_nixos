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
    ./neovim.nix
  ];

  langPackages = with pkgs; [
    clojure
    clojure-lsp
    parinfer-rust
    lumo
    joker
    leiningen
  ];
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
  };
}
