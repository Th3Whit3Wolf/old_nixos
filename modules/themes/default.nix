# Theme modules are a special beast. They're the only modules that are deeply
# intertwined with others, and are solely responsible for aesthetics. Disabling
# a theme module should never leave a system non-functional.

{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.theme;
in {
  options.modules.theme = with types; {
    active = mkOption {
      type = nullOr str;
      default = null;
      apply = v:
        let theme = builtins.getEnv "THEME";
        in if theme != "" then theme else v;
      description = ''
        Name of the theme to enable. Can be overridden by the THEME environment
        variable. Themes can also be hot-swapped with 'hey theme $THEME'.
      '';
    };

    wallpaper = mkOpt (either path null) null;

    loginWallpaper = mkOpt (either path null) (if cfg.wallpaper != null then
      toFilteredImage cfg.wallpaper "-gaussian-blur 0x2 -modulate 70 -level 5%"
    else
      null);

    editor = {
      vscode = {
        extension = mkOption {
          type = types.listOf types.package;
          default = null;
          example = "[ pkgs.vscode-extensions.cometeer.spacemacs ]";
          description = ''
            VScode colorscheme extension.
          '';
        };
        colorTheme = mkOption {
          type = types.str;
          default = "";
          example = "Space-Dark";
          description = ''
            Name of the colorscheme to activate in vscode user settings.
          '';
        };
        fontFamily = mkOption {
          type = types.str;
          default = "";
          example = "JetBrainsMono";
          description = ''
            The family name of the font within the package.
          '';
        };
      };
    };
    gtk = {
      theme = mkOpt str "";
      iconTheme = mkOpt str "";
      font = {
        name = mkOption {
          type = types.str;
          default = "";
          example = "DejaVu Sans";
          description = ''
            The family name of the font within the package.
          '';
        };

        size = mkOption {
          type = types.nullOr types.int;
          default = 12;
          example = "8";
          description = ''
            The size of the font.
          '';
        };
      };
      cursor = {
        name = mkOption {
          type = types.str;
          default = "";
          example = "breeze_cursors";
          description = ''
            The name of the cursor theme
          '';
        };

        size = mkOption {
          type = types.nullOr types.int;
          default = 24;
          example = "8";
          description = ''
            The size of the cursor.
          '';
        };
      };
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

    onReload = mkOpt (attrsOf lines) { };
  };

  config = mkIf (cfg.active != null) (mkMerge [
    # Read xresources files in ~/.config/xtheme/* to allow modular
    # configuration of Xresources.
    (let
      xrdb = ''${pkgs.xorg.xrdb}/bin/xrdb -merge "$XDG_CONFIG_HOME"/xtheme/*'';
    in {
      services.xserver.displayManager.sessionCommands = xrdb;
      modules.theme.onReload.xtheme = xrdb;
    })

    {
      home-manager.users.${config.user.name} = {
        gtk = {
          enable = true;
          theme.name = cfg.gtk.theme;
          iconTheme.name = cfg.gtk.iconTheme;
          font = {
            name = cfg.gtk.font.name;
            size = cfg.gtk.font.size;
          };
          gtk3.extraConfig = {
            gtk-cursor-theme-name = cfg.gtk.cursor.name;
            gtk-cursor-theme-size = cfg.gtk.cursor.size;
            gtk-xft-hinting = 1;
            gtk-xft-hintstyle = "hintfull";
            gtk-xft-rgba = "none";
          };
        };
      };
    }

    (mkIf (cfg.wallpaper != null) (let
      wCfg = config.services.xserver.desktopManager.wallpaper;
      command = ''
        if [ -e "$XDG_DATA_HOME/wallpaper" ]; then
          ${pkgs.feh}/bin/feh --bg-${wCfg.mode} \
            ${optionalString wCfg.combineScreens "--no-xinerama"} \
            --no-fehbg \
            $XDG_DATA_HOME/wallpaper
        fi
      '';
    in {
      # Set the wallpaper ourselves so we don't need .background-image and/or
      # .fehbg polluting $HOME
      services.xserver.displayManager.sessionCommands = command;
      modules.theme.onReload.wallpaper = command;

      home.dataFile =
        mkIf (cfg.wallpaper != null) { "wallpaper".source = cfg.wallpaper; };
    }))

    (mkIf (cfg.loginWallpaper != null) {
      services.xserver.displayManager.lightdm.background = cfg.loginWallpaper;
    })

    (mkIf (cfg.onReload != { }) (let
      reloadTheme = with pkgs;
        (writeScriptBin "reloadTheme" ''
          #!${stdenv.shell}
          echo "Reloading current theme: ${cfg.active}"
          ${concatStringsSep "\n" (mapAttrsToList (name: script: ''
            echo "[${name}]"
            ${script}
          '') cfg.onReload)}
        '');
    in {
      user.packages = [ reloadTheme ];
      system.userActivationScripts.reloadTheme = ''
        [ -z "$NORELOAD" ] && ${reloadTheme}/bin/reloadTheme
      '';
    }))
  ]);
}
