{ config, lib, pkgs, ... }:

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
    ${concatStringsSep "\n"  [
        "${optionalString (length (attrNames cfg.config.definitions ) > 0 ) ewwDefinitions}"
        "${optionalString (length cfg.config.variables.var > 0 || length cfg.config.variables.script-var > 0 ) ewwVars}"
        "${optionalString (length (attrNames cfg.config.windows ) > 0 ) ewwWindows}"
    ]}
  '';

  listOfWidgetTypes = [ "combo-box-text" "expander" "revealer" "checkbox" "color-button" "color-chooser" "scale" "progress" "input" "button" "image" "box" "label" "literal" "calendar" ];

  printWidget = widgetType:
    "${concatStringsSep " " (forEach listOfWidgetTypes (x:
            if widgetType.${x} != null then
            ''
            <${x} ${concatStringsSep " " (mapAttrsToList (name: val: ''${name}="${val}"'') (filterAttrs (n: v: v != null ) widgetType.${x})) }>
            ${if (isString widgetType.content) then "${widgetType.content}" else ''<${widgetType.content.name} ${concatStringsSep " " (mapAttrsToList (name: val: ''${name}="{{${val}}}"'') widgetType.content.args)}/>''}
            </${x}>
            ''
            else ""
        ) widgetType)}";

  ewwIncludess = ''
    <includes>
        <file path="./other_config_file.xml"/>
        <file path="./other_config_file2.xml"/>
    </includes>
  '';

  ewwDefinitions = ''
    <definitions>
        ${concatStringsSep "\n" (mapAttrsToList (name: val:
        ''<def name="${name}">\n${printWidget val}\n</def>''
        ) cfg.config.definitions)}
    </definitions>
  '';

  ewwVars = ''
    <variables>
    ${concatStringsSep "\n"  (mapAttrsToList (name: val:
        ''<var name="${name}">${val}</var>''
    ) cfg.config.variables.var)}
    ${concatStringsSep "\n"  (mapAttrsToList (name: val:
        ''<script-var name="${name}" ${optionalString (val.interval != null) ''interval="${val.interval.duration}${val.interval.unit}"''}>${val.text}</script-var>''
    ) cfg.config.variables.script-var)}
    </variables>
  '';

  ewwWindows = ''
    <windows>
        ${concatStringsSep "\n" (mapAttrsToList (name: val:
        ''<window name="${name}" ${concatStringsSep " " (mapAttrsToList (n: v: ''${n}="${v}"'') (filterAttrs (n: v: n != "reserve" && n != "geometry") val))}>
        <geometry anchor="${val.geometry.anchor}" x="${val.geometry.x}" y="${val.geometry.y}" width="${val.geometry.width}" height="${val.geometry.height}"/>
        ${optionalString cfg.isWayland ''<reserve side="${cfg.config.windows.reserve.side}" distance="${cfg.config.windows.reserve.distance}"/>''}
        <widget>
            <${val.widget}/>
        </widget>
        ''
        ) cfg.config.windows)}
    </windows>
  '';

  AllWidgets = {
    class = mkOption {
      types = with types; nullOr str;
      description = "CSS class name";
      default = null;
    };

    valign = mkOption {
      types = with types; nullOr enum [ "fill" "baseline" "center" "start" "end" ];
      description = "How to align this vertically";
      default = null;
    };

    halign = mkOption {
      types = with types; nullOr enum [ "fill" "baseline" "center" "start" "end" ];
      description = "How to align this horizontally";
      default = null;
    };

    width = mkOption {
      types = with types; nullOr float;
      description = "Width of this element. note that this can not restrict the size if the contents stretch it";
      default = null;
    };

    height = mkOption {
      types = with types; nullOr float;
      description = "Height of this element. note that this can not restrict the size if the contents stretch it";
      default = null;
    };

    active = mkOption {
      types = with types; nullOr bool;
      description = "If this widget can be interacted with";
      default = null;
    };

    tooltip = mkOption {
      types = with types; nullOr str;
      description = "Tooltip text (on hover)";
      default = null;
    };

    visible = mkOption {
      types = with types; nullOr bool;
      description = "Visibility of the widget";
      default = null;
    };

    style = mkOption {
      types = with types; nullOr str;
      description = "Inline CSS style applied to the widget";
      default = null;
    };

    onscroll = mkOption {
      types = with types; nullOr str;
      description = "Event to execute when the user scrolls with the mouse over the widget. The placeholder {} used in the command will be replaced with either up or down.";
      default = null;
    };

    onhover = mkOption {
      types = with types; nullOr str;
      description = "Event to execute when the user hovers over the widget";
      default = null;
    };

    cursor = mkOption {
      types = with types; nullOr str;
      description = "Cursor to show while hovering (see gtk3-cursors for possible names)";
      default = null;
    };
  };

  widgetType = types.submodule ({ config, ... }: {
    options = {
      combo-box-text = mkOption {
        type = nullOr widgetComboTextBoxType;
        description = "A combo box allowing the user to choose between several items.";
        default = null;
      };

      expander = mkOption {
        type = nullOr widgetExpanderType;
        description = "A widget that can expand and collapse, showing/hiding it's children.";
        default = null;
      };

      revealer = mkOption {
        type = nullOr widgetRevealerType;
        description = "A widget that can reveal a child with an animation.";
        default = null;
      };

      checkbox = mkOption {
        type = nullOr widgetCheckboxType;
        description = "A checkbox that can trigger events on checked / unchecked.";
        default = null;
      };

      color-button = mkOption {
        type = nullOr widgetColorButtonType;
        description = "A button opening a color chooser window";
        default = null;
      };

      color-chooser = mkOption {
        type = nullOr widgetColorChooserType;
        description = "A button opening a color chooser window";
        default = null;
      };

      scale = mkOption {
        type = nullOr widgetScaleType;
        description = "A slider";
        default = null;
      };

      progress = mkOption {
        type = nullOr widgetProgressType;
        description = "A progress bar";
        default = null;
      };

      input = mkOption {
        type = nullOr widgetInputType;
        description = "An input field. For this to be useful, set focusable=\"true\" on the window.";
        default = null;
      };

      button = mkOption {
        type = nullOr widgetButtonType;
        description = "A button";
        default = null;
      };

      image = mkOption {
        type = nullOr widgetImageType;
        description = "A widget displaying an image";
        default = null;
      };

      box = mkOption {
        type = nullOr widgetBoxType;
        description = "Main layout container";
        default = null;
      };

      label = mkOption {
        type = nullOr widgetLabelType;
        description = "A text widget giving you more control over how the text is displayed";
        default = null;
      };

      literal = mkOption {
        type = nullOr widgetLiteralType;
        description = "A widget that allows you to render arbitrary XML.";
        default = null;
      };

      calendar = mkOption {
        type = nullOr widgetCalendarType;
        description = "A widget that displays a calendar";
        default = null;
      };

      content = mkOption {
        type = with types; either (str newWidgetType);
        description = "Contents inside widget";
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

  newWidgetType = types.submodule ({ config, ... }: {
    options = {
      name = mkOption {
        type = types.str;
        description = "Name of widget";
        #check = x: elem x (attrNames config.services.eww.config.definitions);
      };
      args = mkOption {
        type = types.attrsOf types.str;
        description = "Arguements to give widget";
      };
    };
  });

  widgetComboTextBoxType = types.submodule ({ config, ... }: {
    options = {
      items = mkOption {
        types = with types; nullOr listOf types.str;
        description = "Items that should be displayed in the combo box";
        default = null;
      };

      onchange = mkOption {
        types = with types; nullOr str;
        description = "Runs the code when a item was selected, replacing {} with the item as a string";
        default = null;
      };
    } // AllWidgets;
  });

  widgetExpanderType = types.submodule ({ config, ... }: {
    options = {
      name = mkOption {
        types = with types; nullOr str;
        description = "Name of the expander";
        default = null;
      };

      expanded = mkOption {
        types = with types; nullOr bool;
        description = "Sets if the tree is expanded";
        default = null;
      };

      vexpand = mkOption {
        types = with types; nullOr bool;
        description = "Should this container expand vertically";
        default = null;
      };

      hexpand = mkOption {
        types = with types; nullOr bool;
        description = "Should this container expand horizontally";
        default = null;
      };
    } // AllWidgets;
  });

  widgetRevealerType = types.submodule ({ config, ... }: {
    options = {
      transition = mkOption {
        types = with types; nullOr enum [ "slideright" "slideleft" "slideup" "slidedown" "crossfade" "none" ];
        description = "Name of the transition.";
        default = null;
      };

      reveal = mkOption {
        types = with types; nullOr bool;
        description = "Sets if the child is revealed or not";
        default = null;
      };

      duration = mkOption {
        type = with types; nullOr duration;
        description = "Duration of the reveal transition";
        default = null;
      };

      vexpand = mkOption {
        types = with types; nullOr bool;
        description = "Should this container expand vertically";
        default = null;
      };

      hexpand = mkOption {
        types = with types; nullOr bool;
        description = "Should this container expand horizontally";
        default = null;
      };
    } // AllWidgets;
  });

  widgetCheckboxType = types.submodule ({ config, ... }: {
    options = {
      onchecked = mkOption {
        types = with types; nullOr str;
        description = "Action (command) to be executed when checked by the user";
        default = null;
      };
      onunchecked = mkOption {
        types = with types; nullOr str;
        description = "Action (command) to be executed when unchecked by the user";
        default = null;
      };
    } // AllWidgets;
  });

  widgetColorButtonType = types.submodule ({ config, ... }: {
    options = {
      use-alpha = mkOption {
        types = with types; nullOr bool;
        description = "Whether or not use alpha";
        default = null;
      };
      onchange = mkOption {
        types = with types; nullOr string;
        description = "Runs the code when the color was selected";
        default = null;
      };
    } // AllWidgets;
  });

  widgetColorChooserType = types.submodule ({ config, ... }: {
    options = {
      use-alpha = mkOption {
        types = with types; nullOr bool;
        description = "Whether or not use alpha";
        default = null;
      };
      onchange = mkOption {
        types = with types; nullOr string;
        description = "Runs the code when the color was selected";
        default = null;
      };
    } // AllWidgets;
  });

  widgetScaleType = types.submodule ({ config, ... }: {
    options = {
      flipped = mkOption {
        types = with types; nullOr bool;
        description = "Flip the directionr";
        default = null;
      };

      draw-value = mkOption {
        types = with types; nullOr bool;
        description = "Draw the value of the property";
        default = null;
      };

      value = mkOption {
        types = with types; nullOr float;
        description = "Current value";
        default = null;
      };

      min = mkOption {
        types = with types; nullOr float;
        description = "Minimum value";
        default = null;
      };

      max = mkOption {
        types = with types; nullOr bool;
        description = "Maximum value";
        default = null;
      };

      onchange = mkOption {
        types = with types; nullOr str;
        description = "Command executed once the value is changes. The placeholder {}, used in the command will be replaced by the new value.";
        default = null;
      };
    } // AllWidgets;
  });

  widgetProgressType = types.submodule ({ config, ... }: {
    options = {
      flipped = mkOption {
        types = with types; nullOr bool;
        description = "Flip the directionr";
        default = null;
      };

      value = mkOption {
        types = with types; nullOr float;
        description = "Value of the progress bar (between 0-100)";
        default = null;
        #check = x: (x >= 0 && x <= 100) || (x == null);
      };

      orientation = mkOption {
        types = with types; nullOr enum [ "vertical" "v" "horizontal" "h" ];
        description = "Orientation of the progress bar.";
        default = null;
      };
    } // AllWidgets;
  });

  widgetInputType = types.submodule ({ config, ... }: {
    options = {
      value = mkOption {
        types = with types; nullOr str;
        description = "Content of the text field";
        default = null;
      };

      onchange = mkOption {
        types = with types; nullOr str;
        description = "Command to run when the text changes. The placeholder {} will be replaced by the value";
        default = null;
      };
    } // AllWidgets;
  });

  widgetButtonType = types.submodule ({ config, ... }: {
    options = {
      onclick = mkOption {
        types = with types; nullOr str;
        description = "Command that get's run when the button is clicked";
        default = null;
      };

      onmiddleclick = mkOption {
        types = with types; nullOr str;
        description = "Command that get's run when the button is middleclicked";
        default = null;
      };

      onrightclick = mkOption {
        types = with types; nullOr str;
        description = "Command that get's run when the button is rightclicked";
        default = null;
      };

      vexpand = mkOption {
        types = with types; nullOr bool;
        description = "Should this container expand vertically";
        default = null;
      };

      hexpand = mkOption {
        types = with types; nullOr bool;
        description = "Should this container expand horizontally";
        default = null;
      };
    } // AllWidgets;
  });

  widgetImageType = types.submodule ({ config, ... }: {
    options = {
      path = mkOption {
        types = with types; nullOr str;
        description = "Path to the image file";
        default = null;
      };

      width = mkOption {
        types = with types; nullOr str;
        description = "Width of the image";
        default = null;
      };

      height = mkOption {
        types = with types; nullOr str;
        description = "Height of the image";
        default = null;
      };
    } // AllWidgets;
  });

  widgetBoxType = types.submodule ({ config, ... }: {
    options = {
      spacing = mkOption {
        types = with types; nullOr str;
        description = "Spacing between elements";
        default = null;
      };

      orientation = mkOption {
        types = with types; nullOr enum [ "vertical" "v" "horizontal" "h" ];
        description = "Orientation of the box";
        default = null;
      };

      space-evenly = mkOption {
        types = with types; nullOr bool;
        description = "Whether to space the widgets evenly.";
        default = null;
      };

      vexpand = mkOption {
        types = with types; nullOr bool;
        description = "Should this container expand vertically";
        default = null;
      };

      hexpand = mkOption {
        types = with types; nullOr bool;
        description = "Should this container expand horizontally";
        default = null;
      };
    } // AllWidgets;
  });

  widgetLabelType = types.submodule ({ config, ... }: {
    options = {
      text = mkOption {
        types = with types; nullOr str;
        description = "The text to display";
        default = null;
      };

      limit-width = mkOption {
        types = with types; nullOr int;
        description = "Maximum count of characters to display";
        default = null;
      };

      markup = mkOption {
        types = with types; nullOr str;
        description = "Pango markup to display";
        default = null;
      };

      wrap = mkOption {
        types = with types; nullOr bool;
        description = "Wrap the text. This mainly makes sense if you set the width of this widget.";
        default = null;
      };

      angle = mkOption {
        types = with types; nullOr float;
        description = "the angle of rotation for the label (between 0 - 360)";
        default = null;
      };
    } // AllWidgets;
  });

  widgetLiteralType = types.submodule ({ config, ... }: {
    options = {
      content = mkOption {
        types = with types; nullOr str;
        description = "Inline Eww XML that will be rendered as a widget.";
        default = null;
      };
    } // AllWidgets;
  });

  widgetCalendarType = types.submodule ({ config, ... }: {
    options = {
      day = mkOption {
        types = with types; nullOr float;
        description = "The selected day";
        default = null;
      };

      month = mkOption {
        types = with types; nullOr float;
        description = "The selected month";
        default = null;
      };

      year = mkOption {
        types = with types; nullOr float;
        description = "The selected year";
        default = null;
      };

      show-details = mkOption {
        types = with types; nullOr bool;
        description = "Show details";
        default = null;
      };

      show-heading = mkOption {
        types = with types; nullOr bool;
        description = "Show heading line";
        default = null;
      };

      show-day-names = mkOption {
        types = with types; nullOr bool;
        description = "Show day names";
        default = null;
      };

      show-week-numbers = mkOption {
        types = with types; nullOr bool;
        description = "Show week numbers";
        default = null;
      };

      onclick = mkOption {
        types = with types; nullOr str;
        description = "Command to run when the user selects a date. The {} placeholder will be replaced by the selected date.";
        default = null;
      };
    } // AllWidgets;
  });

  scriptVariableType = types.submodule ({ config, ... }: {
    options = {
      interval = mkOption {
        types = with types; nullOr duration;
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
        type = types.attrsOf str;
        description = "Allows you to repeat the same text multiple times through without retyping it multiple times.";
      };

      script-vars = mkOption {
        type = types.attrsOf scriptVariableType;
        description = "Allows you to create a script that eww runs.";
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

      /*
        x = mkOption {
        type = numUnit;
        #description = "Allows you to create a script that eww runs.";
        };

        y = mkOption {
        type = numUnit;
        #description = "Allows you to create a script that eww runs.";
        };

        width = mkOption {
        type = numUnit;
        #description = "Allows you to create a script that eww runs.";
        };

        height = mkOption {
        type = numUnit;
        #description = "Allows you to create a script that eww runs.";
        };
      */
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
      /*
        distance = mkOption {
        type = numUnit;
        description = "Allows you to create a script that eww runs.";
        };
      */
      distance = numUnit;
    };
  });

  windowModule = types.submodule ({ config, ... }: {
    options = {
      geometry = mkOption {
        type = geometryModule;
        description = "Allows you to repeat the same text multiple times through without retyping it multiple times.";
      };

      reserve = optionalAttrs (cfg.isWayland) mkOption {
        type = reserveModule;
        description = "Reserve space at a given side of the screen the widget is on.";
      };

      widget = mkOption {
        type = types.str;
        description = "Widget that is shown in the window.";
        check = x: elem x (attrNames cfg.config.definitions);
      };

      stacking = mkOption {
        type = with types; nullOr (if cfg.isWayland then enum [ "fg" "bt" "bg" "ov" ] else enum [ "fg" "bg" ]);
        description = "What \"layer\" of the screen the window is shown.";
        default = null;
      };

      focusable = mkOption {
        type = with types; nullOr enum [ "true" "false" ];
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

      exclusive = optionalAttrs (cfg.isWayland) mkOption {
        type = with types; nullOr enum [ "true" "false" ];
        description = ''
          (Wayland only) Specifies whether or not a surface can be occupied by another.
          A surface can be a window, an Eww widget or any layershell surface.
          The details on how it is actually implemented are left to the compositor.
        '';
        default = null;
      };

      windowtype = optionalAttrs (!cfg.isWayland) mkOption {
        type = with types; nullOr enum [ "normal" "dock" "toolbar" "dialog" ];
        description = ''
          (X11 only) Can be used in determining the decoration, stacking position and other behavior of the window. Possible values
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
        type = types.attrsOf widgetType;
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
        type = types.attrsOf windowModule;
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
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      /*
        assertions = [
        (let
        varsArgs = forEach (cfg.config.variables.var) (x: length attrValues x);
        in
        optionalAttrs (length (cfg.config.variables.var) > 0) {
        assertion = all (x: x == 1) varsArgs;
        message = "Eww: each attr in services.eww.config.variables.var must have exactly 1 value"
        }
        )
        ];
      */

      #home.packages = pkgs.eww;
      systemd.user.services = {
        eww = {
          Unit = {
            Description = "Customizable Widget system daemon";
            PartOf = [ "graphical-session.target" ];
            After = [ "graphical-session.target" ];
          };
          Service = {
            Type = "forking";
            ExecStart = "${pkgs.eww}/bin/eww daemon";
            EnvironmentFile = "${pkgs.writeShellScript "eww-environment" ''
                            export PATH=${lib.escapeShellArg (lib.makeBinPath (with pkgs; [ playerctl curl gnome.nautilus curl ]))}"''${PATH:+:}$PATH"
                        ''}";
            Restart = "on-failure";
            RestartSec = "5sec";
            KillMode = "mixed";
          };
          Install.WantedBy = [ "graphical.target" ];
        };

        eww-logs = {
          Unit = {
            Description = "Eww logs streamed to Systemd";
            After = [ "eww.service" ];
            BindsTo = [ "eww.service" ];
            PartOf = [ "graphical-session.target" ];
          };
          Service = {
            Type = "simple";
            ExecStart = "${pkgs.eww}/bin/eww logs";
            Restart = "on-failure";
          };
          Install.WantedBy = [ "eww.service" ];
        };
      };
    }
    (mkIf (cfg.config.definitions != { } && cfg.config.variables != { } && cfg.config.windows != { }) {

      xdg.configFile."eww/eww.xml" = {
        text = ewwXML;
        onChange = ''
          systemctl --user restart eww.service
        '';
      };
    })
  ]);
}
