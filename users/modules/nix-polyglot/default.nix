{ config, lib, pkgs, ... }:

with lib;
with builtins;

let
    inherit (lib) mkDefault mkIf mkOption mkOpt
    types;

    cfg = config.nix-polyglot;

    languages = flatten (mapAttrsToList (name: type: 
        if type == "directory" then 
            "${name}" 
        else ""  
    ) (readDir (./lang)));

    editorModule = types.submodule ({ config, ... }: {
        options = {
            neovim = {
                enable = mkOption {
                    type = types.bool;
                    default = false;
                    description = "Whether to enable neovim for nix-polyglot.";
                };
                package = mkOption {
                    type = types.package;
                    default = pkgs.neovim-unwrapped;
                    defaultText = literalExample "pkgs.neovim-unwrapped";
                    description = "The package to use for the neovim binary.";
                };
            };

            vscode = {
                enable = mkOption {
                    type = types.bool;
                    default = false;
                    description = "Whether to enable vscode for nix-polyglot.";
                };
                package = mkOption {
                    type = types.package;
                    default = pkgs.vscode;
                    defaultText = literalExample "pkgs.vscode";
                    description = "The vscode package to install.";
                };
            };
        };
    });
in

{
  options.nix-polyglot = {
        enable = mkEnableOption "Enable nix-polyglot";
        editors = mkOption {
            type = editorModule;
            default = {};
            description = "Options related to commands editors configuration.";
        };
        langs = mkOption {
            type = with types; nullOr listOf (enum languages);
            default = [];
            description = "List of languages to use.";
        };
        enableZshIntegration = mkOption {
            default = true;
            type = types.bool;
            description = ''
                Whether to enable Zsh integration.
            '';
        };
    };
}