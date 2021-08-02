{ config, lib, pkgs, home, ... }:

with lib;
with builtins;
let
  cfg = config.services.eww;

  xmlFormat = name: value: pkgs.runCommandNoCC name
    {
      nativeBuildInputs = [ pkgs.xmlformat ];
      value = value;
      passAsFile = [ "value" ];
    } ''
    xmlformat "$valuePath"> $out
  '';

  ewwXML = ''
    <eww>
    ${concatStringsSep "\n"  [
        "${optionalString (length cfg.config.definitions > 0 ) ewwDefinitions}"
        "${optionalString (length (attrNames cfg.config.variables.vars) > 0 || length (attrNames cfg.config.variables.script-vars) > 0 ) ewwVars}"
        "${optionalString (length (attrNames cfg.config.windows ) > 0 ) ewwWindows}"
      ]}
      </eww>'';

  stringy = v:
    if isInt v then toString v
    else if (isBool v && v == true) then "true"
    else if (isBool v && v == false) then "false"
    else v;

  ewwDefinitions = ''
    <definitions>
      ${concatStringsSep "\n" cfg.config.definitions}
    </definitions>'';

  ewwVars = ''
    <variables>
      ${concatStringsSep "\n"  (mapAttrsToList (name: val:
          "<var name=\"${name}\">\n\t${val}\n</var>"
      ) cfg.config.variables.vars)}
      ${concatStringsSep "\n"  (mapAttrsToList (name: val:
          "<script-var name=\"${name}\" ${if (val.interval != null) then ''interval="${toString val.interval.quantity}${val.interval.units}"'' else ""}>\n\t${val.text}\n</script-var>"
      ) cfg.config.variables.script-vars)}
    </variables>
  '';

  printEwwWindow = windowValue:
    ''
      ${concatStringsSep " " (mapAttrsToList (name: value: ''${name}="${stringy value}"'') (filterAttrs (n: v: n != "geometry" && n != "reserve" && n != "widget" && v != null) windowValue) )}>
      <geometry ${concatStringsSep " " (mapAttrsToList (gName: gValue: ''${gName}="${gValue}"'') windowValue.geometry)}/>${optionalString (!cfg.isWayland) ("\n<reserve ${concatStringsSep " " (mapAttrsToList (rName: rValue: ''${rName}="${rValue}"'') windowValue.geometry)}/>")}
      <widget>
        <${windowValue.widget}/>
      </widget>
    '';

  ewwWindows =
    if cfg.isWayland then ''
      <windows>
        ${concatStringsSep "\n" (
          mapAttrsToList (windowName: WindowValue: ''
          <window name="${windowName}" ${printEwwWindow WindowValue}
            </window>
          '')(cfg.config.windows)
        )}
      </windows>
    '' else ''
      <windows>

      </windows>
    '';

  scriptVariableType = types.submodule ({ config, ... }: {
    options = {
      interval = mkOption {
        type = with types; nullOr duration;
        description = "What interval should the script update";
        default = null;
      };

      text = mkOption {
        type = types.str;
        description = "What the script will do";
        default = "";
      };
    };
  });

  variableModule = types.submodule ({ config, ... }: {
    options = {
      vars = mkOption {
        type = types.attrsOf types.str;
        description = "Allows you to repeat the same text multiple times through without retyping it multiple times.";
      };

      script-vars = mkOption {
        type = types.attrsOf scriptVariableType;
        description = "Allows you to create a script that eww runs.";
      };
    };
  });

  duration = types.submodule ({ config, ... }: {
    options = {
      quantity = mkOption {
        type = types.int;
        description = "Quantity of time to set duration";
      };

      units = mkOption {
        type = types.enum [ "m" "Miliseconds" "s" "Seconds" "m" "Minutes" "h" "Hours" ];
        description = "Units of time to set duration";
      };
    };
  });

  numUnit = mkOption {
    type = types.str;
    description = "A distance measure in pixles or percents";
    #check = x: if (hasSuffix "%" x) then (builtins.tryEval (toInt (removeSuffix "%" x))).success else if (hasSuffix "px" x) then ((builtins.tryEval (toInt (removeSuffix "px" x))).success && (toInt x < 100)) else false;
  };

  geometryModule = types.submodule ({ config, ... }: {
    options = {
      anchor = mkOption {
        type = types.enum [ "top left" "top center" "top right" "center left" "center" "center right" "bottom left" "bottom center" "bottom right" ];
        description = "Allows you to repeat the same text multiple times through without retyping it multiple times.";
      };
      x = numUnit;
      y = numUnit;
      width = numUnit;
      height = numUnit;
    };
  });

  reserveModule = types.submodule ({ config, ... }: {
    options = {
      side = mkOption {
        type = types.enum [ "left" "top" "right" "bottom" ];
        description = "Allows you to repeat the same text multiple times through without retyping it multiple times.";
      };
      distance = numUnit;
    };
  });

  windowModuleWayland = types.submodule ({ config, ... }: {
    options = {
      geometry = mkOption {
        type = geometryModule;
        description = "Allows you to repeat the same text multiple times through without retyping it multiple times.";
      };

      widget = mkOption {
        type = types.str;
        description = "Widget that is shown in the window.";
        #check = x: elem x (attrNames cfg.config.definitions);
      };

      stacking = mkOption {
        type = with types; nullOr (enum [ "fg" "bt" "bg" "ov" ]);
        description = "What \"layer\" of the screen the window is shown.";
        default = null;
      };

      focusable = mkOption {
        type = with types; nullOr bool;
        description = ''
          Whether the window should be focusable by the windowmanager.
          This is necessary for things like text-input-fields to work properly.
        '';
        default = null;
      };

      screen = mkOption {
        type = with types; nullOr int;
        description = ''
          Specifies on which display to show the window in a multi-monitor setup.
          This can be any number, representing the index of your monitor.
        '';
        default = null;
      };

      exclusive = mkOption {
        type = with types; nullOr bool;
        description = ''
          (Wayland only) Specifies whether or not a surface can be occupied by another.
          A surface can be a window, an Eww widget or any layershell surface.
          The details on how it is actually implemented are left to the compositor.
        '';
        default = null;
      };
    };
  });

  windowModuleX11 = types.submodule ({ config, ... }: {
    options = {
      geometry = mkOption {
        type = geometryModule;
        description = "Allows you to repeat the same text multiple times through without retyping it multiple times.";
      };

      reserve = mkOption {
        type = reserveModule;
        description = "Reserve space at a given side of the screen the widget is on.";
      };

      widget = mkOption {
        type = types.str;
        description = "Widget that is shown in the window.";
        #check = x: elem x (attrNames cfg.config.definitions);
      };

      stacking = mkOption {
        type = with types; nullOr (enum [ "fg" "bg" ]);
        description = "What \"layer\" of the screen the window is shown.";
        default = null;
      };

      focusable = mkOption {
        type = with types; nullOr bool;
        description = ''
          Whether the window should be focusable by the windowmanager.
          This is necessary for things like text-input-fields to work properly.
        '';
        default = null;
      };

      screen = mkOption {
        type = with types; nullOr int;
        description = ''
          Specifies on which display to show the window in a multi-monitor setup.
          This can be any number, representing the index of your monitor.
        '';
        default = null;
      };

      windowtype = mkOption {
        type = with types; nullOr (enum [ "normal" "dock" "toolbar" "dialog" ]);
        description = ''
            Can be used in determining the decoration, stacking position and other behavior of the window. Possible values
          * "normal": indicates that this is a normal, top-level window
          * "dock": indicates a dock or panel feature
          * "toolbar": toolbars "torn off" from the main application
          * "dialog": indicates that this is a dialog window
        '';
        default = null;
      };
    };
  });

  configModule = types.submodule ({ config, ... }: {
    options = {
      definitions = mkOption {
        type = types.listOf types.str;
        description = ''
          List of widget definitions
        '';
      };

      variables = mkOption {
        type = variableModule;
        description = ''
          List of eww variables and script-variables
        '';
      };

      windows = mkOption {
        type = types.attrsOf (if cfg.isWayland then windowModuleWayland else windowModuleX11);
        description = ''
          List of windows
        '';
      };
    };
  });


in
{
  options = {
    services.eww = {
      enable = mkEnableOption "Elkowar's Wacky Widgets";
      isWayland = mkEnableOption "Enable for wayland";
      config = mkOption {
        type = configModule;
        default = { };
        description = "Options eww configuration options.";
      };
      style = mkOption {
        type = with types; nullOr (either path str);
        default = { };
        description = "Options eww configuration options.";
      };
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      /*
        assertions = [
        (let
        varsArgs = forEach (cfg.config.variables.vars) (x: length attrValues x);
        in
        optionalAttrs (length (cfg.config.variables.vars) > 0) {
        assertion = all (x: x == 1) varsArgs;
        message = "Eww: each attr in services.eww.config.variables.vars must have exactly 1 value"
        }
        )
        ];

      */
      home.packages = [ pkgs.eww ];

      systemd.user = {
        services = {
          eww = {
            Unit = {
              Description = "Customizable Widget system daemon";
              PartOf = [ "graphical-session.target" ];
              After = [ "graphical-session.target" ];
            };
            Service = {
              Type = "forking";
              ExecStart = "${pkgs.eww}/bin/eww -c ${config.home.homeDirectory}/.config/eww daemon";
              #EnvironmentFile = "${config.home.homeDirectory}/";
              Restart = "on-failure";
              RestartSec = "5sec";
              KillMode = "mixed";
            };
            Install.WantedBy = [ "graphical.target" ];
          };

          eww-bar = {
            Unit = {
              Description = "Eww statusbar";
              After = [ "eww.service" ];
              BindsTo = [ "eww.service" ];
              PartOf = [ "graphical-session.target" ];
            };
            Service = {
              Type = "simple";
              ExecStart = "${pkgs.eww}/bin/eww -c ${config.home.homeDirectory}/.config/eww open bar";
              Restart = "on-failure";
            };
            Install.WantedBy = [ "eww.service" ];
          };
        };
        startServices = true;
      };
    }
    (mkIf (cfg.config.definitions != { } && cfg.config.variables != { } && cfg.config.windows != { }) {

      xdg.configFile."eww/eww.xml" = {
        source = xmlFormat "eww.xml" ewwXML;
        #text = ewwXML;
        onChange = ''
          systemctl --user restart eww.service
        '';
      };
    })
    (mkIf (cfg.style != null) {
      xdg.configFile."eww/eww.scss" =
        if (isPath cfg.style) then {
          source = cfg.style;
          onChange = ''
            systemctl --user restart eww.service
          '';
        } else {
          text = cfg.style;
          onChange = ''
            systemctl --user restart eww.service
          '';
        };
    })
  ]);
}

# nrfs
# sudo systemctl restart home-manager-doc.service && systemctl status home-manager-doc.service

