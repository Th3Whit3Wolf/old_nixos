{ config, lib, pkgs, ... }:

{
  home.nix-polyglot = {
    enable = true;
    langs = [ "all" ];
    enableZshIntegration = false;
    neovim.enable = true;
    vscode = {
      enable = true;
      package = pkgs.vscodium;
    };
  };
}

/*
  pathVar = [ "$(${pkgs.yarn}/bin/yarn global bin)" "$(${pkgs.nodejs}/bin/npm bin)" ];
  pathVar = [ "$CARGO_HOME/bin" ];
*/
