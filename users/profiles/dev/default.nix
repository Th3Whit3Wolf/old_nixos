{ pkgs, ... }:

{
  nix-polyglot = {
    langs = [ "cc" "lua" "nix" "rust" ];
    enableZshIntegration = true;
    neovim.enable = true;
    vscode = {
      enable = true;
      package = pkgs.vscodium;
    };
  };
}
