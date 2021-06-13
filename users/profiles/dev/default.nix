{ pkgs, ... }:

{
  nix-polyglot = {
        langs = [ "all" ];
        enableZshIntegration = true;
        neovim.enable = true;
        vscode = {
          enable = true;
          package = pkgs.vscodium;
        };
    };
}
