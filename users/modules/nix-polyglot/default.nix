{ config, lib, pkgs, ... }:

with lib;
with builtins;

let
  inherit (lib) mkDefault mkIf mkOption mkOpt types;

  cfg = config.nix-polyglot;
  languages = flatten
    (mapAttrsToList (name: type: if type == "directory" then "${name}" else "")
      (readDir (./lang))) ++ [ "all" ];

  polyglotPackages = with pkgs; [ git-ignore licensor just dotenv-linter ];

in
{
  imports = [ ./neovim.nix ./vscode ./lang ];

  /*
    * Should have strong integrations with many editors
    * VSCODE   - In Progress
    * NVIM     - Started
    * EMACS    - Not Started
    * KAKOUNE  - Not Started
    * HELIX    - Not Started

    Browser extension:
    * Github: https://github.com/stefanbuck/awesome-browser-extensions-for-github
    * react devtools - nur.repos.rycee.firefox-addons.react-devtools
    * vue devtools - https://github.com/vuejs/devtools
    * https://github.com/huhu/rust-search-extension
  */

  options.nix-polyglot = {
    enable = mkEnableOption "Enable nix-polyglot";
    langs = mkOption {
      type = with types; nullOr (listOf (enum languages));
      default = [ ];
      description = "List of languages to use.";
    };
    enableZshIntegration = mkOption {
      default = true;
      type = types.bool;
      description = ''
        Whether to enable Zsh integration.
      '';
    };
    packages = mkOption {
      type = types.listOf types.package;
      default = polyglotPackages;
      example =
        literalExample "with pkgs; [ git-ignore licensor just dotenv-linter ]";
      description = ''
        List of generic packages to install for development.
      '';
    };
  };
  config = mkIf cfg.enable { home.packages = nix-polyglot.packages; };
}

/*
  "dashboard.projectData": null
*/
