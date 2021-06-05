{ config, lib, pkgs, ... }:

let

  inherit (lib) mkDefault mkIf mkOption mkOpt
    types;

in
{
  imports = [ ./spaceDark ];

  #   TODO
  #   Add packages that are required to be installed
  #   Add fonts that are required to be installed
  options = {
    home.theme = with types; {
      name = mkOption {
        type = with types; nullOr str;
        example = "Space Dark";
        description = ''
          The theme name.
        '';
      };
      wallpaper = mkOption {
        type = with types; nullOr path;
        example = "../Wallpaper/1.jpg";
        description = ''
          The theme wallpaper.
        '';
      };
      vt = {
        red = mkOption {
          type = types.str;
          default = "";
          example =
            "0x2e,0xd7,0x66,0x5f,0xff,0xaf,0xcd,0xb2,0x2e,0x1f,0x00,0x00,0xff,0xd7,0xff,0xff";
          description = ''
            List of red values to be used for linux console colors.
          '';
        };
        grn = mkOption {
          type = types.str;
          default = "";
          example =
            "0x2e,0xd7,0x66,0x5f,0xff,0xaf,0xcd,0xb2,0x2e,0x1f,0x00,0x00,0xff,0xd7,0xff,0xff";
          description = ''
            List of green values to be used for linux console colors.
          '';
        };
        blu = mkOption {
          type = types.str;
          default = "";
          example =
            "0x2e,0xd7,0x66,0x5f,0xff,0xaf,0xcd,0xb2,0x2e,0x1f,0x00,0x00,0xff,0xd7,0xff,0xff";
          description = ''
            List of blue values to be used for linux console colors.
          '';
        };
      };
      requiredPackages = mkOption {
        type = types.listOf types.package;
        default = [ ];
        example = literalExample "[ pkgs.firefox pkgs.thunderbird ]";
        description = ''
          The set of packages that are required for the theme
        '';
      };
    };
  };
}
