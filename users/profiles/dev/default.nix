{ config, lib, pkgs, ... }:

let
  inherit (config.home) homeDirectory;
in
{
  home = {
    nix-polyglot = {
      enable = true;
      langs = [ "all" ];
      enableZshIntegration = false;
      neovim.enable = true;
      vscode = {
        enable = true;
        package = pkgs.vscodium;
      };
    };
    sessionVariables = {
      HELIX_RUNTIME = "${homeDirectory}/.config/helix/runtime";
    };
  };
  systemd.user.sessionVariables = {
    HELIX_RUNTIME = "${homeDirectory}/.config/helix/runtime";
  };
  services.gpg-agent.pinentryFlavor = "gnome3";
}

/*
  pathVar = [ "$(${pkgs.yarn}/bin/yarn global bin)" "$(${pkgs.nodejs}/bin/npm bin)" ];
  pathVar = [ "$CARGO_HOME/bin" ];
*/
