{ config, lib, pkgs, ... }:

let

  inherit (lib) mkDefault mkIf mkOption types;

in
{
  imports = [ ./spaceDark ];
  options = {
    home.theme = mkOption {
      type = types.str;
      example = "Space Dark";
      description = ''
        The theme name.
      '';
    };
  };
}
