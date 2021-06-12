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

    polyglotPackages = with pkgs; [
        git-ignore
        licensor
    ];
in

{
  imports = [ ./neovim.nix  ./vscode.nix ./lang ];

  options.nix-polyglot = {
        enable = mkEnableOption "Enable nix-polyglot";
        langs = mkOption {
            type = with types; nullOr (listOf (enum languages));
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
        packages = mkOption {
            type = types.listOf types.package;
            default = polyglotPackages;
            example = literalExample "[ pkgs.git-ignore pkgs.licensor ]";
            description = ''
            List of generic packages to install for development.
            '';
        };
    };
    config = mkIf cfg.enable {
        home.packages = nix-polyglot.packages;
    };
}