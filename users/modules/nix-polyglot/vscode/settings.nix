{ config, lib, pkgs, ... }:

with lib;
with types;
# Default vscode settings https://code.visualstudio.com/docs/getstarted/settings
{
  options.nix-polyglot.vscode.userSettings = {
    diffEditor = {
      codeLens = mkOption {
        type = bool;
        default = false;
        description = ''
          Controls whether the editor shows CodeLens.
        '';
      };
      ignoreTrimWhitespace = mkOption {
        type = bool;
        default = true;
        description = ''
          When enabled, the diff editor ignores changes in leading or trailing whitespace.
        '';
      };
      maxComputationTime = mkOption {
        type = int;
        default = 5000;
        description = ''
          Timeout in milliseconds after which diff computation is cancelled. Use 0 for no timeout.
        '';
      };
      renderIndicators = mkOption {
        type = bool;
        default = true;
        description = ''
          Controls whether the diff editor shows +/- indicators for added/removed changes.
        '';
      };
      renderSideBySide = mkOption {
        type = bool;
        default = true;
        description = ''
          Controls whether the diff editor shows the diff side by side or inline.
        '';
      };
      wordWrap = mkOption {
        type = enum [ "off" "on" "inherit" ];
        default = "inherit";
        description = ''
          - off: Lines will never wrap.
          - on: Lines will wrap at the viewport width.
          - inherit: Lines will wrap according to the `editor.wordWrap` setting.
        '';
      };
    };
    editor = {
      acceptSuggestionOnCommitCharacter = mkOption {
        type = bool;
        default = true;
        description = ''
          Controls whether suggestions should be accepted on commit characters. For example, in JavaScript, the semi-colon (`;`) can be a commit character that accepts a suggestion and types that character.
        '';
      };
      acceptSuggestionOnEnter = mkOption {
        type = enum [ "on" "smart" "off" ];
        default = "on";
        description = ''
          Controls whether suggestions should be accepted on `Enter`, in addition to `Tab`. Helps to avoid ambiguity between inserting new lines or accepting suggestions.
            - on
            - smart: Only accept a suggestion with `Enter` when it makes a textual change.
            - off
        '';
      };
      accessibilitySupport = mkOption {
        type = enum [ "auto" "on" "off" ];
        default = "auto";
        description = ''
          Controls whether the editor should run in a mode where it is optimized for screen readers. Setting to on will disable word wrapping.
            - auto: The editor will use platform APIs to detect when a Screen Reader is attached.
            - on: The editor will be permanently optimized for usage with a Screen Reader. Word wrapping will be disabled.
            - off: The editor will never be optimized for usage with a Screen Reader.
        '';
      };
      autoClosingBrackets = mkOption {
        type = enum [ "always" "languageDefined" "beforeWhitespace" "never" ];
        default = "languageDefined";
        description = ''
          Controls whether the editor should automatically close brackets after the user adds an opening bracket.
            - always
            - languageDefined: Use language configurations to determine when to autoclose brackets.
            - beforeWhitespace: Autoclose brackets only when the cursor is to the left of whitespace.
            - never
        '';
      };
      autoClosingDelete = mkOption {
        type = enum [ "always" "auto" "never" ];
        default = "auto";
        description = ''
          Controls whether the editor should remove adjacent closing quotes or brackets when deleting.
            - always
            - auto: Remove adjacent closing quotes or brackets only if they were automatically inserted.
            - never
        '';
      };
      autoClosingOvertype = mkOption {
        type = enum [ "always" "auto" "never" ];
        default = "auto";
        description = ''
          Controls whether the editor should type over closing quotes or brackets.
            - always
            - auto: Type over closing quotes or brackets only if they were automatically inserted.
            - never
        '';
      };
      autoClosingQuotes = mkOption {
        type = enum [ "always" "languageDefined" "beforeWhitespace" "never" ];
        default = "languageDefined";
        description = ''
          Controls whether the editor should automatically close quotes after the user adds an opening bracket.
            - always
            - languageDefined: Use language configurations to determine when to autoclose quotes.
            - beforeWhitespace: Autoclose quotes only when the cursor is to the left of whitespace.
            - never
        '';
      };
      autoIndent = mkOption {
        type = enum [ "none" "keep" "brackets" "advanced" "full" ];
        default = "full";
        description = ''
          Controls whether the editor should automatically adjust the indentation when users type, paste, move or indent lines.
            - none: The editor will not insert indentation automatically.
            - keep: The editor will keep the current line's indentation.
            - brackets: The editor will keep the current line's indentation and honor language defined brackets.
            - advanced: The editor will keep the current line's indentation, honor language defined brackets and invoke special onEnterRules defined by languages.
            - full: The editor will keep the current line's indentation, honor language defined brackets, invoke special onEnterRules defined by languages, and honor indentationRules defined by languages.
        '';
      };
      autoSurround = mkOption {
        type = enum [ "languageDefined" "quotes" "brackets" "never" ];
        default = "languageDefined";
        description = ''
          Controls whether the editor should automatically surround selections when typing quotes or brackets.
            - languageDefined: Use language configurations to determine when to automatically surround selections.
            - quotes: Surround with quotes but not brackets.
            - brackets: Surround with brackets but not quotes
            - never
        '';
      };
      codeActionsOnSave = mkOption {
        type = either (attrsOf bool) (listOf str);
        default = { };
        description = ''
          Code action kinds to be run on save.
        '';
      };
      codeLens = mkOption {
        type = bool;
        default = true;
        description = ''
          Controls whether the editor shows CodeLens.
        '';
      };
      codeLensFontFamily = mkOption {
        type = str;
        default = "";
        description = ''
          Controls the font family for CodeLens.
        '';
      };
      codeLensFontSize = mkOption {
        type = int;
        default = 0;
        description = ''
          Controls the font size in pixels for CodeLens. When set to `0`, the 90% of `editor.fontSize` is used.
        '';
      };
      colorDecorators = mkOption {
        type = bool;
        default = true;
        description = ''
          Controls whether the editor should render the inline color decorators and color picker.
        '';
      };
      columnSelection = mkOption {
        type = bool;
        default = false;
        description = ''
          Enable that the selection with the mouse and keys is doing column selection.
        '';
      };
      comments = {
        ignoreEmptyLines = mkOption {
          type = bool;
          default = true;
          description = ''
            Controls if empty lines should be ignored with toggle, add or remove actions for line comments.
          '';
        };
        insertSpace = mkOption {
          type = bool;
          default = true;
          description = ''
            Controls whether a space character is inserted when commenting.
          '';
        };
      };
      copyWithSyntaxHighlighting = mkOption {
        type = bool;
        default = true;
        description = ''
          Controls whether syntax highlighting should be copied into the clipboard.
        '';
      };
      cursorBlinking = mkOption {
        type = enum [ "blink" "smooth" "phase" "expand" "solid" ];
        default = "blink";
        description = ''
          Control the cursor animation style.
        '';
      };
      cursorSmoothCaretAnimation = mkOption {
        type = bool;
        default = false;
        description = ''
          Controls whether the smooth caret animation should be enabled.
        '';
      };
      cursorStyle = mkOption {
        type = enum [
          "line"
          "block"
          "underline"
          "line-thin"
          "block-outline"
          "underline-thin"
        ];
        default = "line";
        description = ''
          Controls the cursor style.
        '';
      };
      cursorSurroundingLines = mkOption {
        type = int;
        default = 0;
        description = ''
          Controls the minimal number of visible leading and trailing lines surrounding the cursor. Known as 'scrollOff' or 'scrollOffset' in some other editors.
        '';
      };
      cursorSurroundingLinesStyle = mkOption {
        type = enum [ "default" "all" ];
        default = "default";
        description = ''
          Controls when `cursorSurroundingLines` should be enforced.
            - default: `cursorSurroundingLines` is enforced only when triggered via the keyboard or API.
            - all: `cursorSurroundingLines` is enforced always.
        '';
      };
      cursorWidth = mkOption {
        type = int;
        default = 0;
        description = ''
          Controls the width of the cursor when `editor.cursorStyle` is set to `line`.
        '';
      };
      defaultFormatter = mkOption {
        type = nullOr (str);
        default = null;
        description = ''
          Defines a default formatter which takes precedence over all other formatter settings. Must be the identifier of an extension contributing a formatter.
        '';
      };
      definitionLinkOpensInPeek = mkOption {
        type = bool;
        default = false;
        description = ''
          Controls whether the Go to Definition mouse gesture always opens the peek widget.
        '';
      };
      detectIndentation = mkOption {
        type = bool;
        default = true;
        description = ''
          Controls whether `editor.tabSize#` and `#editor.insertSpaces` will be automatically detected when a file is opened based on the file contents.
        '';
      };
      dragAndDrop = mkOption {
        type = bool;
        default = true;
        description = ''
          Controls whether the editor should allow moving selections via drag and drop.
        '';
      };
      emptySelectionClipboard = mkOption {
        type = bool;
        default = true;
        description = ''
          Controls whether copying without a selection copies the current line.
        '';
      };
      fastScrollSensitivity = mkOption {
        type = int;
        default = 5;
        description = ''
          Scrolling speed multiplier when pressing `Alt`.
        '';
      };
      find = {
        addExtraSpaceOnTop = mkOption {
          type = bool;
          default = true;
          description = ''
            Controls whether the Find Widget should add extra lines on top of the editor. When true, you can scroll beyond the first line when the Find Widget is visible.
          '';
        };
        autoFindInSelection = mkOption {
          type = enum [ "never" "always" "multiline" ];
          default = "never";
          description = ''
            Controls the condition for turning on find in selection automatically.
              - never: Never turn on Find in selection automatically (default).
              - always: Always turn on Find in selection automatically.
              - multiline: Turn on Find in selection automatically when multiple lines of content are selected.
          '';
        };
        cursorMoveOnType = mkOption {
          type = bool;
          default = true;
          description = ''
            Controls whether the cursor should jump to find matches while typing.
          '';
        };
        globalFindClipboard = mkOption {
          type = bool;
          default = false;
          description = ''
            Controls whether the Find Widget should read or modify the shared find clipboard on macOS.
          '';
        };
        loop = mkOption {
          type = bool;
          default = true;
          description = ''
            Controls whether the search automatically restarts from the beginning (or the end) when no further matches can be found.
          '';
        };
        seedSearchStringFromSelection = mkOption {
          type = bool;
          default = true;
          description = ''
            Controls whether the search string in the Find Widget is seeded from the editor selection.
          '';
        };
        folding = mkOption {
          type = bool;
          default = true;
          description = ''
            Controls whether the editor has code folding enabled.
          '';
        };
      };
      foldingHighlight = mkOption {
        type = bool;
        default = true;
        description = ''
          Controls whether the editor should highlight folded ranges.
        '';
      };
      foldingStrategy = mkOption {
        type = enum [ "auto" "indentation" ];
        default = "auto";
        description = ''
          Controls the strategy for computing folding ranges.
            - auto: Use a language-specific folding strategy if available, else the indentation-based one.
            - indentation: Use the indentation-based folding strategy.
        '';
      };
      fontFamily = mkOption {
        type = str;
        default = "Consolas, 'Courier New', monospace";
        description = ''
          Controls the font family.
        '';
      };
      fontLigatures = mkOption {
        type = bool;
        default = false;
        description = ''
          Configures font ligatures or font features.
          Can be either a boolean to enable/disable ligatures or a string for the value of the CSS 'font-feature-settings' property.
        '';
      };
      fontSize = mkOption {
        type = int;
        default = 14;
        description = ''
          Controls the font size in pixels.
        '';
      };
      fontWeight = mkOption {
        type =
          enum [ "normal" "bold" 100 200 300 400 500 600 700 800 900 1000 ];
        default = "normal";
        description = ''
          Controls the font weight. Accepts "normal" and "bold" keywords or numbers between 1 and 1000.
        '';
      };
      formatOnPaste = mkOption {
        type = bool;
        default = false;
        description = ''
          Controls whether the editor should automatically format the pasted content. A formatter must be available and the formatter should be able to format a range in a document.
        '';
      };
      formatOnSave = mkOption {
        type = bool;
        default = false;
        description = ''
          Format a file on save. A formatter must be available, the file must not be saved after delay, and the editor must not be shutting down.
        '';
      };
      formatOnSaveMode = mkOption {
        type = enum [ "file" "modifications" ];
        default = "file";
        description = ''
          Controls if format on save formats the whole file or only modifications. Only applies when `editor.formatOnSave` is enabled.
          - file: Format the whole file.
          - modifications: Format modifications (requires source control).
        '';
      };
      formatOnType = mkOption {
        type = bool;
        default = false;
        description = ''
          Controls whether the editor should automatically format the line after typing.
        '';
      };
      glyphMargin = mkOption {
        type = bool;
        default = true;
        description = ''
          Controls whether the editor should render the vertical glyph margin. Glyph margin is mostly used for debugging.
        '';
      };
      gotoLocation = {
        alternativeDeclarationCommand = mkOption {
          type = enum [
            "editor.action.referenceSearch.trigger"
            "editor.action.goToReferences"
            "editor.action.peekImplementation"
            "editor.action.goToImplementation"
            "editor.action.peekTypeDefinition"
            "editor.action.goToTypeDefinition"
            "editor.action.peekDeclaration"
            "editor.action.revealDeclaration"
            "editor.action.peekDefinition"
            "editor.action.revealAsideDefinition"
            "editor.action.revealDefinition"
            ""
          ];
          default = "editor.action.goToReferences";
          description = ''
            Alternative command id that is being executed when the result of 'Go to Declaration' is the current location.
          '';
        };
        alternativeImplementationCommand = mkOption {
          type = enum [
            "editor.action.referenceSearch.trigger"
            "editor.action.goToReferences"
            "editor.action.peekImplementation"
            "editor.action.goToImplementation"
            "editor.action.peekTypeDefinition"
            "editor.action.goToTypeDefinition"
            "editor.action.peekDeclaration"
            "editor.action.revealDeclaration"
            "editor.action.peekDefinition"
            "editor.action.revealAsideDefinition"
            "editor.action.revealDefinition"
            ""
          ];
          default = "";
          description = ''
            Alternative command id that is being executed when the result of 'Go to Declaration' is the current location.
          '';
        };
        alternativeReferenceCommand = mkOption {
          type = enum [
            "editor.action.referenceSearch.trigger"
            "editor.action.goToReferences"
            "editor.action.peekImplementation"
            "editor.action.goToImplementation"
            "editor.action.peekTypeDefinition"
            "editor.action.goToTypeDefinition"
            "editor.action.peekDeclaration"
            "editor.action.revealDeclaration"
            "editor.action.peekDefinition"
            "editor.action.revealAsideDefinition"
            "editor.action.revealDefinition"
            ""
          ];
          default = "";
          description = ''
            Alternative command id that is being executed when the result of 'Go to Declaration' is the current location.
          '';
        };
        alternativeTypeDefinitionCommand = mkOption {
          type = enum [
            "editor.action.referenceSearch.trigger"
            "editor.action.goToReferences"
            "editor.action.peekImplementation"
            "editor.action.goToImplementation"
            "editor.action.peekTypeDefinition"
            "editor.action.goToTypeDefinition"
            "editor.action.peekDeclaration"
            "editor.action.revealDeclaration"
            "editor.action.peekDefinition"
            "editor.action.revealAsideDefinition"
            "editor.action.revealDefinition"
            ""
          ];
          default = "editor.action.goToReferences";
          description = ''
            Alternative command id that is being executed when the result of 'Go to Declaration' is the current location.
          '';
        };
        multipleDeclarations = mkOption {
          type = enum [ "peek" "gotoAndPeek" "goto" ];
          default = "peek";
          description = ''
            Controls the behavior the 'Go to Declaration'-command when multiple target locations exist.
              - peek: Show peek view of the results (default)
              - gotoAndPeek: Go to the primary result and show a peek view
              - goto: Go to the primary result and enable peek-less navigation to others
          '';
        };
        multipleDefinitions = mkOption {
          type = enum [ "peek" "gotoAndPeek" "goto" ];
          default = "peek";
          description = ''
            Controls the behavior the 'Go to Definition'-command when multiple target locations exist.
              - peek: Show peek view of the results (default)
              - gotoAndPeek: Go to the primary result and show a peek view
              - goto: Go to the primary result and enable peek-less navigation to others
          '';
        };
        multipleImplementations = mkOption {
          type = enum [ "peek" "gotoAndPeek" "goto" ];
          default = "peek";
          description = ''
            Controls the behavior the 'Go to Implementations'-command when multiple target locations exist.
              - peek: Show peek view of the results (default)
              - gotoAndPeek: Go to the primary result and show a peek view
              - goto: Go to the primary result and enable peek-less navigation to others
          '';
        };
        multipleReferences = mkOption {
          type = enum [ "peek" "gotoAndPeek" "goto" ];
          default = "peek";
          description = ''
            Controls the behavior the 'Go to References'-command when multiple target locations exist.
              - peek: Show peek view of the results (default)
              - gotoAndPeek: Go to the primary result and show a peek view
              - goto: Go to the primary result and enable peek-less navigation to others
          '';
        };
        multipleTypeDefinitions = mkOption {
          type = enum [ "peek" "gotoAndPeek" "goto" ];
          default = "peek";
          description = ''
            Controls the behavior the 'Go to Type Definition'-command when multiple target locations exist.
              - peek: Show peek view of the results (default)
              - gotoAndPeek: Go to the primary result and show a peek view
              - goto: Go to the primary result and enable peek-less navigation to others
          '';
        };
      };
      hideCursorInOverviewRuler = mkOption {
        type = bool;
        default = false;
        description = ''
          Controls whether the cursor should be hidden in the overview ruler.
        '';
      };
      highlightActiveIndentGuide = mkOption {
        type = bool;
        default = true;
        description = ''
          Controls whether the cursor should be hidden in the overview ruler.
        '';
      };
      hover = {
        delay = mkOption {
          type = int;
          default = 300;
          description = ''
            Controls the delay in milliseconds after which the hover is shown.
          '';
        };
        enabled = mkOption {
          type = bool;
          default = true;
          description = ''
            Controls whether the hover is shown.
          '';
        };
        sticky = mkOption {
          type = bool;
          default = true;
          description = ''
            Controls whether the hover should remain visible when mouse is moved over it.
          '';
        };
      };
      inlayHints = {
        enabled = mkOption {
          type = bool;
          default = true;
          description = ''
            Enables the inlay hints in the editor.
          '';
        };
        fontFamily = mkOption {
          type = str;
          default = "Consolas, 'Courier New', monospace";
          description = ''
            Controls font family of inlay hints in the editor.
          '';
        };
        fontSize = mkOption {
          type = int;
          default = 0;
          description = ''
            Controls font size of inlay hints in the editor. When set to `0`, the 90% of `editor.fontSize` is used.
          '';
        };
      };
      insertSpaces = mkOption {
        type = bool;
        default = true;
        description = ''
          Insert spaces when pressing `Tab`. This setting is overridden based on the file contents when `editor.detectIndentation` is on.
        '';
      };
      letterSpacing = mkOption {
        type = int;
        default = 0;
        description = ''
          Controls the letter spacing in pixels.
        '';
      };
      lightbulb = {
        enabled = mkOption {
          type = bool;
          default = true;
          description = ''
            Enables the code action lightbulb in the editor.
          '';
        };
      };
      lineHeight = mkOption {
        type = int;
        default = 0;
        description = ''
          Controls the line height. Use 0 to compute the line height from the font size.
        '';
      };
      lineNumbers = mkOption {
        type = enum [ "off" "on" "relative" "interval" ];
        default = "on";
        description = ''
          Controls the display of line numbers.
          - off: Line numbers are not rendered.
          - on: Line numbers are rendered as absolute number.
          - relative: Line numbers are rendered as distance in lines to cursor position.
          - interval: Line numbers are rendered every 10 lines.
        '';
      };
      linkedEditing = mkOption {
        type = bool;
        default = false;
        description = ''
          Controls whether the editor has linked editing enabled. Depending on the language, related symbols, e.g. HTML tags, are updated while editing.
        '';
      };
      links = mkOption {
        type = bool;
        default = true;
        description = ''
          Controls whether the editor should detect links and make them clickable.
        '';
      };
      matchBrackets = mkOption {
        type = enum [ "always" "near" "never" ];
        default = "always";
        description = ''
          Highlight matching brackets.
        '';
      };
      minimap = {
        enabled = mkOption {
          type = bool;
          default = false;
          description = ''
            Controls whether the minimap is shown.
          '';
        };
        maxColumn = mkOption {
          type = int;
          default = 120;
          description = ''
            Limit the width of the minimap to render at most a certain number of columns.
          '';
        };
        renderCharacters = mkOption {
          type = bool;
          default = true;
          description = ''
            Controls whether the minimap is shown.
          '';
        };
        scale = mkOption {
          type = enum [ 1 2 3 ];
          default = 1;
          description = ''
            Scale of content drawn in the minimap: 1, 2 or 3.
          '';
        };
        showSlider = mkOption {
          type = enum [ "mouseover" "always" ];
          default = "mouseover";
          description = ''
            Controls when the minimap slider is shown.
          '';
        };
        side = mkOption {
          type = enum [ "right" "left" ];
          default = "right";
          description = ''
            Controls the side where to render the minimap.
          '';
        };
        size = mkOption {
          type = enum [ "proportional" "fill" "fit" ];
          default = "proportional";
          description = ''
            Controls the size of the minimap.
              - proportional: The minimap has the same size as the editor contents (and might scroll).
              - fill: The minimap will stretch or shrink as necessary to fill the height of the editor (no scrolling).
              - fit: The minimap will shrink as necessary to never be larger than the editor (no scrolling).
          '';
        };
      };
      mouseWheelScrollSensitivity = mkOption {
        type = int;
        default = 1;
        description = ''
          A multiplier to be used on the `deltaX` and `deltaY` of mouse wheel scroll events.
        '';
      };
      mouseWheelZoom = mkOption {
        type = bool;
        default = false;
        description = ''
          Zoom the font of the editor when using mouse wheel and holding `Ctrl`.
        '';
      };
      multiCursorModifier = mkOption {
        type = enum [ "ctrlCmd" "alt" ];
        default = "alt";
        description = ''
          The modifier to be used to add multiple cursors with the mouse. The Go To Definition and Open Link mouse gestures will adapt such that they do not conflict with the multicursor modifier.
            - ctrlCmd: Maps to `Control` on Windows and Linux and to `Command` on macOS.
            - alt: Maps to `Alt` on Windows and Linux and to `Option` on macOS.
        '';
      };
      multiCursorPaste = mkOption {
        type = enum [ "spread" "paste" ];
        default = "spread";
        description = ''
          Controls pasting when the line count of the pasted text matches the cursor count.
            - spread: Each cursor pastes a single line of the text.
            - full: Each cursor pastes the full text.
        '';
      };
      occurrencesHighlight = mkOption {
        type = bool;
        default = true;
        description = ''
          Controls whether the editor should highlight semantic symbol occurrences.
        '';
      };
      overviewRulerBorder = mkOption {
        type = bool;
        default = true;
        description = ''
          Controls whether a border should be drawn around the overview ruler.
        '';
      };
      padding = {
        bottom = mkOption {
          type = int;
          default = 0;
          description = ''
            Controls the amount of space between the bottom edge of the editor and the last line.
          '';
        };
        top = mkOption {
          type = int;
          default = 0;
          description = ''
            Controls the amount of space between the bottom edge of the editor and the first line.
          '';
        };
      };
      parameterHints = {
        cycle = mkOption {
          type = bool;
          default = false;
          description = ''
            Controls whether the parameter hints menu cycles or closes when reaching the end of the list.
          '';
        };
        enabled = mkOption {
          type = bool;
          default = true;
          description = ''
            Enables a pop-up that shows parameter documentation and type information as you type.
          '';
        };
      };
      peekWidgetDefaultFocus = mkOption {
        type = enum [ "tree" "editor" ];
        default = "tree";
        description = ''
          Controls whether to focus the inline editor or the tree in the peek widget.
            - tree: Focus the tree when opening peek
            - editor: Focus the editor when opening peek
        '';
      };
      quickSuggestions = mkOption {
        type = attrsOf bool;
        default = {
          "other" = true;
          "comments" = false;
          "strings" = false;
        };
        description = ''
          Controls whether suggestions should automatically show up while typing.
        '';
      };
      quickSuggestionsDelay = mkOption {
        type = int;
        default = 10;
        description = ''
          Controls the delay in milliseconds after which quick suggestions will show up.
        '';
      };
      rename = {
        enablePreview = mkOption {
          type = bool;
          default = true;
          description = ''
            Enable/disable the ability to preview changes before renaming.
          '';
        };
      };
      renderControlCharacters = mkOption {
        type = bool;
        default = false;
        description = ''
          Controls whether the editor should render control characters.
        '';
      };
      renderFinalNewline = mkOption {
        type = bool;
        default = false;
        description = ''
          Render last line number when the file ends with a newline.
        '';
      };
      renderIndentGuides = mkOption {
        type = bool;
        default = false;
        description = ''
          Controls whether the editor should render control characters.Controls whether the editor should render indent guides.
        '';
      };
      renderLineHighlight = mkOption {
        type = enum [ "none" "gutter" "line" "all" ];
        default = "line";
        description = ''
          Controls how the editor should render the current line highlight.
            - none
            - gutter
            - line
            - all: Highlights both the gutter and the current line.
        '';
      };
      renderLineHighlightOnlyWhenFocus = mkOption {
        type = bool;
        default = false;
        description = ''
          Controls if the editor should render the current line highlight only when the editor is focused.
        '';
      };
      renderWhitespace = mkOption {
        type = enum [ "none" "boundary" "selection" "trailing" "all" ];
        default = "selection";
        description = ''
          Controls how the editor should render whitespace characters.
            - none
            - boundary: Render whitespace characters except for single spaces between words.
            - selection: Render whitespace characters only on selected text.
            - trailing: Render only trailing whitespace characters.
            - all
        '';
      };
      roundedSelection = mkOption {
        type = bool;
        default = true;
        description = ''
          Controls whether selections should have rounded corners.
        '';
      };
      rulers = mkOption {
        type = listOf int;
        default = [ ];
        description = ''
          Render vertical rulers after a certain number of monospace characters. Use multiple values for multiple rulers. No rulers are drawn if array is empty.
        '';
      };
      scrollBeyondLastColumn = mkOption {
        type = int;
        default = 5;
        description = ''
          Controls the number of extra characters beyond which the editor will scroll horizontally.
        '';
      };
      scrollBeyondLastLine = mkOption {
        type = bool;
        default = true;
        description = ''
          Controls whether the editor will scroll beyond the last line.
        '';
      };
      selectionClipboard = mkOption {
        type = bool;
        default = true;
        description = ''
          Controls whether the Linux primary clipboard should be supported.
        '';
      };
      scrollPredominantAxis = mkOption {
        type = bool;
        default = true;
        description = ''
          Scroll only along the predominant axis when scrolling both vertically and horizontally at the same time. Prevents horizontal drift when scrolling vertically on a trackpad.
        '';
      };
      selectionHighlight = mkOption {
        type = bool;
        default = true;
        description = ''
          Controls whether the editor should highlight matches similar to the selection.
        '';
      };
      semanticHighlighting = {
        enabled = mkOption {
          type = enum [ true false "configuredByTheme" ];
          default = "configuredByTheme";
          description = ''
            Controls whether the semanticHighlighting is shown for the languages that support it.
              - true: Semantic highlighting enabled for all color themes.
              - false: Semantic highlighting disabled for all color themes.
              - configuredByTheme: Semantic highlighting is configured by the current color theme's `semanticHighlighting` setting.
          '';
        };
      };
      semanticTokenColorCustomizations = mkOption {
        type = attrsOf attrs;
        default = { };
        description = ''
          Overrides editor semantic token color and styles from the currently selected color theme.
        '';
      };
      showDeprecated = mkOption {
        type = bool;
        default = true;
        description = ''
          Controls strikethrough deprecated variables.
        '';
      };
      showFoldingControls = mkOption {
        type = enum [ "always" "mouseover" ];
        default = "mouseover";
        description = ''
          Controls when the folding controls on the gutter are shown.
            - always: Always show the folding controls.
            - mouseover: Only show the folding controls when the mouse is over the gutter.
        '';
      };
      showUnused = mkOption {
        type = bool;
        default = true;
        description = ''
          Controls fading out of unused code.
        '';
      };
      smartSelect = {
        selectLeadingAndTrailingWhitespace = mkOption {
          type = bool;
          default = true;
          description = ''
            Whether leading and trailing whitespace should always be selected.
          '';
        };
      };
      smoothScrolling = mkOption {
        type = bool;
        default = true;
        description = ''
          Controls whether the editor will scroll using an animation.
        '';
      };
      snippetSuggestions = mkOption {
        type = enum [ "top" "bottom" "inline" "none" ];
        default = "inline";
        description = ''
          Controls whether snippets are shown with other suggestions and how they are sorted.
            - top: Show snippet suggestions on top of other suggestions.
            - bottom: Show snippet suggestions below other suggestions.
            - inline: Show snippets suggestions with other suggestions.
            - none: Do not show snippet suggestions.
        '';
      };
      stablePeek = mkOption {
        type = bool;
        default = false;
        description = ''
          Keep peek editors open even when double clicking their content or when hitting `Escape`.
        '';
      };
      stickyTabStops = mkOption {
        type = bool;
        default = false;
        description = ''
          Emulate selection behavior of tab characters when using spaces for indentation. Selection will stick to tab stops.
        '';
      };
      suggest = {
        filterGraceful = mkOption {
          type = bool;
          default = true;
          description = ''
            Controls whether filtering and sorting suggestions accounts for small typos.
          '';
        };
        insertMode = mkOption {
          type = enum [ "insert" "replace" ];
          default = "insert";
          description = ''
            Controls whether words are overwritten when accepting completions. Note that this depends on extensions opting into this feature.
              - insert: Insert suggestion without overwriting text right of the cursor.
              - replace: Insert suggestion and overwrite text right of the cursor.
          '';
        };
        localityBonus = mkOption {
          type = bool;
          default = false;
          description = ''
            Controls whether sorting favors words that appear close to the cursor.
          '';
        };
        shareSuggestSelections = mkOption {
          type = bool;
          default = false;
          description = ''
            Controls whether remembered suggestion selections are shared between multiple workspaces and windows (needs `editor.suggestSelection`).
          '';
        };
        showClasses = mkOption {
          type = bool;
          default = true;
          description = ''
            When enabled IntelliSense shows `class`-suggestions.
          '';
        };
        showColors = mkOption {
          type = bool;
          default = true;
          description = ''
            When enabled IntelliSense shows `color`-suggestions.
          '';
        };
        showConstants = mkOption {
          type = bool;
          default = true;
          description = ''
            When enabled IntelliSense shows `constant`-suggestions.
          '';
        };
        showConstructors = mkOption {
          type = bool;
          default = true;
          description = ''
            When enabled IntelliSense shows `constructor`-suggestions.
          '';
        };
        showCustomcolors = mkOption {
          type = bool;
          default = true;
          description = ''
            When enabled IntelliSense shows `customcolor`-suggestions.
          '';
        };
        showDeprecated = mkOption {
          type = bool;
          default = true;
          description = ''
            When enabled IntelliSense shows `deprecated`-suggestions.
          '';
        };
        showEnumMembers = mkOption {
          type = bool;
          default = true;
          description = ''
            When enabled IntelliSense shows `enumMember`-suggestions.
          '';
        };
        showEnums = mkOption {
          type = bool;
          default = true;
          description = ''
            When enabled IntelliSense shows `enum`-suggestions.
          '';
        };
        showEvents = mkOption {
          type = bool;
          default = true;
          description = ''
            When enabled IntelliSense shows `event`-suggestions.
          '';
        };
        showFields = mkOption {
          type = bool;
          default = true;
          description = ''
            When enabled IntelliSense shows `field`-suggestions.
          '';
        };
        showFiles = mkOption {
          type = bool;
          default = true;
          description = ''
            When enabled IntelliSense shows `file`-suggestions.
          '';
        };
        showFolders = mkOption {
          type = bool;
          default = true;
          description = ''
            When enabled IntelliSense shows `folder`-suggestions.
          '';
        };
        showFunctions = mkOption {
          type = bool;
          default = true;
          description = ''
            When enabled IntelliSense shows `function`-suggestions.
          '';
        };
        showIcons = mkOption {
          type = bool;
          default = true;
          description = ''
            Controls whether to show or hide icons in suggestions.
          '';
        };
        showInlineDetails = mkOption {
          type = bool;
          default = true;
          description = ''
            Controls whether suggest details show inline with the label or only in the details widget.
          '';
        };
        showInterfaces = mkOption {
          type = bool;
          default = true;
          description = ''
            When enabled IntelliSense shows `interface`-suggestions.
          '';
        };
        showIssues = mkOption {
          type = bool;
          default = true;
          description = ''
            When enabled IntelliSense shows `issues`-suggestions.
          '';
        };
        showKeywords = mkOption {
          type = bool;
          default = true;
          description = ''
            When enabled IntelliSense shows `keyword`-suggestions.
          '';
        };
        showMethods = mkOption {
          type = bool;
          default = true;
          description = ''
            When enabled IntelliSense shows `method`-suggestions.
          '';
        };
        showModules = mkOption {
          type = bool;
          default = true;
          description = ''
            When enabled IntelliSense shows `module`-suggestions.
          '';
        };
        showOperators = mkOption {
          type = bool;
          default = true;
          description = ''
            When enabled IntelliSense shows `operator`-suggestions.
          '';
        };
        showProperties = mkOption {
          type = bool;
          default = true;
          description = ''
            When enabled IntelliSense shows `property`-suggestions.
          '';
        };
        showReferences = mkOption {
          type = bool;
          default = true;
          description = ''
            When enabled IntelliSense shows `reference`-suggestions.
          '';
        };
        showSnippets = mkOption {
          type = bool;
          default = true;
          description = ''
            When enabled IntelliSense shows `snippet`-suggestions.
          '';
        };
        showStatusBar = mkOption {
          type = bool;
          default = false;
          description = ''
            Controls the visibility of the status bar at the bottom of the suggest widget.
          '';
        };
        showStructs = mkOption {
          type = bool;
          default = true;
          description = ''
            When enabled IntelliSense shows `struct`-suggestions.
          '';
        };
        showTypeParameters = mkOption {
          type = bool;
          default = true;
          description = ''
            When enabled IntelliSense shows `typeParameter`-suggestions.
          '';
        };
        showUnits = mkOption {
          type = bool;
          default = true;
          description = ''
            When enabled IntelliSense shows `unit`-suggestions.
          '';
        };
        showUsers = mkOption {
          type = bool;
          default = true;
          description = ''
            When enabled IntelliSense shows `user`-suggestions.
          '';
        };
        showValues = mkOption {
          type = bool;
          default = true;
          description = ''
            When enabled IntelliSense shows `value`-suggestions.
          '';
        };
        showVariables = mkOption {
          type = bool;
          default = true;
          description = ''
            When enabled IntelliSense shows `variable`-suggestions.
          '';
        };
        showWords = mkOption {
          type = bool;
          default = true;
          description = ''
            When enabled IntelliSense shows `text`-suggestions.
          '';
        };
        snippetsPreventQuickSuggestions = mkOption {
          type = bool;
          default = true;
          description = ''
            Controls whether an active snippet prevents quick suggestions.
          '';
        };
      };
      suggestFontSize = mkOption {
        type = int;
        default = 0;
        description = ''
          Font size for the suggest widget. When set to `0`, the value of `editor.fontSize` is used.
        '';
      };
      suggestLineHeight = mkOption {
        type = int;
        default = 0;
        description = ''
          Line height for the suggest widget. When set to `0`, the value of `editor.lineHeight` is used. The minimum value is 8.
        '';
      };
      suggestOnTriggerCharacters = mkOption {
        type = bool;
        default = true;
        description = ''
          Controls whether suggestions should automatically show up when typing trigger characters.
        '';
      };
      suggestSelection = mkOption {
        type = enum [ "first" "recentlyUsed" "recentlyUsedByPrefix" ];
        default = "recentlyUsed";
        description = ''
          Controls how suggestions are pre-selected when showing the suggest list.
            - first: Always select the first suggestion.
            - recentlyUsed: Select recent suggestions unless further typing selects one, e.g. `console.| -> console.log` because `log` has been completed recently.
            - recentlyUsedByPrefix: Select suggestions based on previous prefixes that have completed those suggestions, e.g. `co -> console` and `con -> const`.
        '';
      };
      tabCompletion = mkOption {
        type = enum [ "on" "off" "onlySnippets" ];
        default = "off";
        description = ''
          Enables tab completions.
            - on: Tab complete will insert the best matching suggestion when pressing tab.
            - off: Disable tab completions.
            - onlySnippets: Tab complete snippets when their prefix match. Works best when 'quickSuggestions' aren't enabled.
        '';
      };
      tabSize = mkOption {
        type = int;
        default = 4;
        description = ''
          The number of spaces a tab is equal to. This setting is overridden based on the file contents when `editor.detectIndentation` is on.
        '';
      };
      tokenColorCustomizations = mkOption {
        type = attrsOf attrs;
        default = { };
        description = ''
          Overrides editor syntax colors and font style from the currently selected color theme.
        '';
      };
      trimAutoWhitespace = mkOption {
        type = bool;
        default = true;
        description = ''
          Remove trailing auto inserted whitespace.
        '';
      };
      unfoldOnClickAfterEndOfLine = mkOption {
        type = bool;
        default = false;
        description = ''
          Controls whether clicking on the empty content after a folded line will unfold the line.
        '';
      };
      unusualLineTerminators = mkOption {
        type = enum [ "auto" "off" "prompt" ];
        default = "prompt";
        description = ''
          Remove unusual line terminators that might cause problems.
            - auto: Unusual line terminators are automatically removed.
            - off: Unusual line terminators are ignored.
            - prompt: Unusual line terminators prompt to be removed.
        '';
      };
      useTabStops = mkOption {
        type = bool;
        default = true;
        description = ''
          Inserting and deleting whitespace follows tab stops.
        '';
      };
      wordBasedSuggestions = mkOption {
        type = bool;
        default = true;
        description = ''
          Controls whether completions should be computed based on words in the document.
        '';
      };
      wordBasedSuggestionsMode = mkOption {
        type = enum [ "currentDocument" "matchingDocuments" "allDocuments" ];
        default = "matchingDocuments";
        description = ''
          Controls from which documents word based completions are computed.
            - currentDocument: Only suggest words from the active document.
            - matchingDocuments: Suggest words from all open documents of the same language.
            - allDocuments: Suggest words from all open documents.
        '';
      };
      wordSeparators = mkOption {
        type = str;
        default = ''`~!@#$%^&*()-=+[{]}\|;:'",.<>/?'';
        description = ''
          Characters that will be used as word separators when doing word related navigations or operations.
        '';
      };
      wordWrap = mkOption {
        type = enum [ "off" "on" "wordWrapColumn" "bounded" ];
        default = "off";
        description = ''
          Controls how lines should wrap.
            - off: Lines will never wrap.
            - on: Lines will wrap at the viewport width.
            - wordWrapColumn: Lines will wrap at `editor.wordWrapColumn`.
            - bounded: Lines will wrap at the minimum of viewport and `editor.wordWrapColumn`.
        '';
      };
      wordWrapColumn = mkOption {
        type = int;
        default = 80;
        description = ''
          Controls the wrapping column of the editor when `editor.wordWrap` is `wordWrapColumn` or `bounded`.
        '';
      };
      wrappingIndent = mkOption {
        type = enum [ "none" "same" "indent" "deepIndent" ];
        default = "same";
        description = ''
          Controls the indentation of wrapped lines.
            - none: No indentation. Wrapped lines begin at column 1.
            - same: Wrapped lines get the same indentation as the parent.
            - indent: Wrapped lines get +1 indentation toward the parent.
            - deepIndent: Wrapped lines get +2 indentation toward the parent.
        '';
      };
      wrappingStrategy = mkOption {
        type = enum [ "simple" "advanced" ];
        default = "simple";
        description = ''
          Controls the algorithm that computes wrapping points.
            - simple: Assumes that all characters are of the same width. This is a fast algorithm that works correctly for monospace fonts and certain scripts (like Latin characters) where glyphs are of equal width.
            - advanced: Delegates wrapping points computation to the browser. This is a slow algorithm, that might cause freezes for large files, but it works correctly in all cases.
        '';
      };
    };
    scm = {
      alwaysShowActions = mkOption {
        type = bool;
        default = false;
        description = ''
          Controls whether inline actions are always visible in the Source Control view.
        '';
      };
      alwaysShowRepositories = mkOption {
        type = bool;
        default = false;
        description = ''
          Controls whether repositories should always be visible in the SCM view.
        '';
      };
      autoReveal = mkOption {
        type = bool;
        default = true;
        description = ''
          Controls whether the SCM view should automatically reveal and select files when opening them.
        '';
      };
      countBadge = mkOption {
        type = enum [ "all" "focused" "off" ];
        default = "all";
        description = ''
          Controls the count badge on the Source Control icon on the Activity Bar.
            - all: Show the sum of all Source Control Provider count badges.
            - focused: Show the count badge of the focused Source Control Provider.
            - off: Disable the Source Control count badge.
        '';
      };
      defaultViewMode = mkOption {
        type = enum [ "tree" "list" ];
        default = "list";
        description = ''
          Controls the default Source Control repository view mode.
            - tree: Show the repository changes as a tree.
            - list: Show the repository changes as a list.
        '';
      };
      diffDecorations = mkOption {
        type = enum [ "all" "gutter" "overview" "minimap" "none" ];
        default = "all";
        description = ''
          Controls diff decorations in the editor.
            - all: Show the diff decorations in all available locations.
            - gutter: Show the diff decorations only in the editor gutter.
            - overview: Show the diff decorations only in the overview ruler.
            - minimap: Show the diff decorations only in the minimap.
            - none: Do not show the diff decorations.
        '';
      };
      diffDecorationsGutterAction = mkOption {
        type = enum [ "diff" "none" ];
        default = "diff";
        description = ''
          Controls the behavior of Source Control diff gutter decorations.
            - diff: Show the inline diff peek view on click.
            - none: Do nothing.
        '';
      };
      diffDecorationsGutterVisibility = mkOption {
        type = enum [ "always" "hover" ];
        default = "always";
        description = ''
          Controls the visibility of the Source Control diff decorator in the gutter.
            - always: Show the diff decorator in the gutter at all times.
            - hover: Show the diff decorator in the gutter only on hover.
        '';
      };
      diffDecorationsGutterWidth = mkOption {
        type = int;
        default = 3;
        description = ''
          Controls the width(px) of diff decorations in gutter (added & modified).
        '';
      };
      inputFontFamily = mkOption {
        type = str;
        default = "default";
        description = ''
          Controls the font for the input message. Use `default` for the workbench user interface font family, `editor` for the `editor.fontFamily`'s value, or a custom font family.
        '';
      };
      inputFontSize = mkOption {
        type = int;
        default = 13;
        description = ''
          Controls the font size for the input message in pixels.
        '';
      };
      providerCountBadge = mkOption {
        type = enum [ "hidden" "auto" "visible" ];
        default = "hidden";
        description = ''
          Controls the count badges on Source Control Provider headers. These headers only appear when there is more than one provider.
            - hidden: Hide Source Control Provider count badges.
            - auto: Only show count badge for Source Control Provider when non-zero.
            - visible: Show Source Control Provider count badges.
        '';
      };
      repositories = {
        inputFontSize = mkOption {
          type = int;
          default = 10;
          description = ''
            Controls how many repositories are visible in the Source Control Repositories section. Set to `0` to be able to manually resize the view.
          '';
        };
      };
    };
    security = {
      workspace = {
        trust = {
          emptyWindow = mkOption {
            type = bool;
            default = true;
            description = ''
              Controls whether or not the empty window is trusted by default within VS Code.
            '';
          };
          enabled = mkOption {
            type = bool;
            default = true;
            description = ''
              Controls whether or not Workspace Trust is enabled within VS Code.
            '';
          };
          startupPrompt = mkOption {
            type = enum [ "always" "once" "never" ];
            default = "once";
            description = ''
              Controls when the startup prompt to trust a workspace is shown.
                - always: Ask for trust every time an untrusted workspace is opened.
                - once: Ask for trust the first time an untrusted workspace is opened.
                - never: Do not ask for trust when an untrusted workspace is opened.
            '';
          };
          untrustedFiles = mkOption {
            type = enum [ "prompt" "open" "newWindow" ];
            default = "prompt";
            description = ''
              Controls how to handle opening untrusted files in a trusted workspace.
                - prompt: Ask how to handle untrusted files for each workspace. Once untrusted files are introduced to a trusted workspace, you will not be prompted again.
                - open: Always allow untrusted files to be introduced to a trusted workspace without prompting.
                - newWindow: Always open untrusted files in a separate window in restricted mode without prompting.
            '';
          };
        };
      };
    };
    workbench = {
      activityBar = {
        iconClickBehavior = mkOption {
          type = enum [ "toggle" "focus" ];
          default = "toggle";
          description = ''
            Controls the behavior of clicking an activity bar icon in the workbench.
              - toggle: Hide the side bar if the clicked item is already visible.
              - focus: Focus side bar if the clicked item is already visible.
          '';
        };
        visible = mkOption {
          type = bool;
          default = true;
          description = ''
            Controls the visibility of the activity bar in the workbench.
          '';
        };
      };
      colorCustomizations = mkOption {
        type = attrsOf attrs;
        default = { };
        description = ''
          Overrides colors from the currently selected color theme.
        '';
      };
      colorTheme = mkOption {
        type = str;
        default = "Default Dark+";
        description = ''
          Specifies the color theme used in the workbench.
        '';
      };
      commandPalette = {
        history = mkOption {
          type = int;
          default = 50;
          description = ''
            Controls the number of recently used commands to keep in history for the command palette. Set to 0 to disable command history.
          '';
        };
        preserveInput = mkOption {
          type = bool;
          default = false;
          description = ''
            Controls whether the last typed input to the command palette should be restored when opening it the next time.
          '';
        };
      };
      editor = {
        centeredLayoutAutoResize = mkOption {
          type = bool;
          default = true;
          description = ''
            Controls if the centered layout should automatically resize to maximum width when more than one group is open. Once only one group is open it will resize back to the original centered width.
          '';
        };
        closeEmptyGroups = mkOption {
          type = bool;
          default = true;
          description = ''
            Controls the behavior of empty editor groups when the last tab in the group is closed. When enabled, empty groups will automatically close. When disabled, empty groups will remain part of the grid.
          '';
        };
        closeOnFileDelete = mkOption {
          type = bool;
          default = false;
          description =
            "Controls whether editors showing a file that was opened during the session should close automatically when getting deleted or renamed by some other process. Disabling this will keep the editor open  on such an event. Note that deleting from within the application will always close the editor and that dirty files will never close to preserve your data.          ";
        };
        decorations = {
          badges = mkOption {
            type = bool;
            default = true;
            description = ''
              Controls whether editor file decorations should use badges.
            '';
          };
          colors = mkOption {
            type = bool;
            default = true;
            description = ''
              Controls whether editor file decorations should use colors.
            '';
          };
        };
        enablePreview = mkOption {
          type = bool;
          default = true;
          description = ''
            Controls whether opened editors show as preview. Preview editors do not keep open and are reused until explicitly set to be kept open (e.g. via double click or editing) and show up with an italic font style.
          '';
        };
        enablePreviewFromCodeNavigation = mkOption {
          type = bool;
          default = false;
          description = ''
            Controls whether editors remain in preview when a code navigation is started from them. Preview editors do not keep open and are reused until explicitly set to be kept open (e.g. via double click or editing). This value is ignored when `workbench.editor.enablePreview` is disabled.
          '';
        };
        enablePreviewFromQuickOpen = mkOption {
          type = bool;
          default = false;
          description = ''
            Controls whether editors opened from Quick Open show as preview. Preview editors do not keep open and are reused until explicitly set to be kept open (e.g. via double click or editing). This value is ignored when `workbench.editor.enablePreview` is disabled.
          '';
        };
        focusRecentEditorAfterClose = mkOption {
          type = bool;
          default = true;
          description = ''
            Controls whether tabs are closed in most recently used order or from left to right.
          '';
        };
        highlightModifiedTabs = mkOption {
          type = bool;
          default = false;
          description = ''
            Controls whether a top border is drawn on modified (dirty) editor tabs or not. This value is ignored when `workbench.editor.showTabs` is disabled.
          '';
        };
        labelFormat = mkOption {
          type = enum [ "default" "short" "medium" "long" ];
          default = "default";
          description = ''
            Controls the format of the label for an editor.
              - default: Show the name of the file. When tabs are enabled and two files have the same name in one group the distinguishing sections of each file's path are added. When tabs are disabled, the path relative to the workspace folder is shown if the editor is active.
              - short: Show the name of the file followed by its directory name.
              - medium: Show the name of the file followed by its path relative to the workspace folder.
              - long: Show the name of the file followed by its absolute path.
          '';
        };
        limit = {
          enabled = mkOption {
            type = bool;
            default = false;
            description = ''
              Controls if the number of opened editors should be limited or not. When enabled, less recently used editors that are not dirty will close to make space for newly opening editors.
            '';
          };
          perEditorGroup = mkOption {
            type = bool;
            default = false;
            description = ''
              Controls if the limit of maximum opened editors should apply per editor group or across all editor groups.
            '';
          };
          value = mkOption {
            type = int;
            default = 10;
            description = ''
              Controls the maximum number of opened editors. Use the `workbench.editor.limit.perEditorGroup` setting to control this limit per editor group or across all groups.
            '';
          };
        };
        mouseBackForwardToNavigate = mkOption {
          type = bool;
          default = true;
          description = ''
            Navigate between open files using mouse buttons four and five if provided.
          '';
        };
        openPositioning = mkOption {
          type = enum [ "left" "right" "first" "last" ];
          default = "right";
          description = ''
            Controls where editors open. Select `left` or `right` to open editors to the left or right of the currently active one. Select `first` or `last` to open editors independently from the currently active one.
          '';
        };
        openSideBySideDirection = mkOption {
          type = enum [ "right" "down" ];
          default = "right";
          description = ''
            Controls the default direction of editors that are opened side by side (for example, from the Explorer). By default, editors will open on the right hand side of the currently active one. If changed to `down`, the editors will open below the currently active one.
          '';
        };
        pinnedTabSizing = mkOption {
          type = enum [ "normal" "compact" "shrink" ];
          default = "normal";
          description = ''
            Controls the sizing of pinned editor tabs. Pinned tabs are sorted to the beginning of all opened tabs and typically do not close until unpinned. This value is ignored when `workbench.editor.showTabs` is disabled.
              - normal: A pinned tab inherits the look of non pinned tabs.
              - compact: A pinned tab will show in a compact form with only icon or first letter of the editor name.
              - shrink: A pinned tab shrinks to a compact fixed size showing parts of the editor name.
          '';
        };
        restoreViewState = mkOption {
          type = bool;
          default = true;
          description = ''
            Restores the last view state (e.g. scroll position) when re-opening textual editors after they have been closed.
          '';
        };
        revealIfOpen = mkOption {
          type = bool;
          default = false;
          description = ''
            Controls whether an editor is revealed in any of the visible groups if opened. If disabled, an editor will prefer to open in the currently active editor group. 
            If enabled, an already opened editor will be revealed instead of opened again in the currently active editor group. Note that there are some cases where this setting is ignored, e.g. when forcing an editor to open in a specific group or to the side of the currently active group.
          '';
        };
        scrollToSwitchTabs = mkOption {
          type = bool;
          default = false;
          description = ''
            Controls whether scrolling over tabs will open them or not. By default tabs will only reveal upon scrolling, but not open. 
            You can press and hold the Shift-key while scrolling to change this behavior for that duration. This value is ignored when `workbench.editor.showTabs` is disabled.
          '';
        };
        showIcons = mkOption {
          type = bool;
          default = true;
          description = ''
            Controls whether opened editors should show with an icon or not. This requires a file icon theme to be enabled as well.
          '';
        };
        showTabs = mkOption {
          type = bool;
          default = true;
          description = ''
            Controls whether opened editors should show in tabs or not.
          '';
        };
        splitOnDragAndDrop = mkOption {
          type = bool;
          default = true;
          description = ''
            Controls if editor groups can be split from drag and drop operations by dropping an editor or file on the edges of the editor area.
          '';
        };
        splitSizing = mkOption {
          type = enum [ "distribute" "split" ];
          default = "distribute";
          description = ''
            Controls the sizing of editor groups when splitting them.
              - distribute: Splits all the editor groups to equal parts.
              - split: Splits the active editor group to equal parts.
          '';
        };
        tabCloseButton = mkOption {
          type = enum [ "left" "right" "off" ];
          default = "right";
          description = ''
            Controls the position of the editor's tabs close buttons, or disables them when set to 'off'. This value is ignored when `workbench.editor.showTabs` is disabled.
          '';
        };
        tabSizing = mkOption {
          type = enum [ "fit" "shrink" ];
          default = "fit";
          description = ''
            Controls the sizing of editor tabs. This value is ignored when `workbench.editor.showTabs` is disabled.
              - fit: Always keep tabs large enough to show the full editor label.
              - shrink: Allow tabs to get smaller when the available space is not enough to show all tabs at once.
          '';
        };
        titleScrollbarSizing = mkOption {
          type = enum [ "default" "large" ];
          default = "default";
          description = ''
            Controls the height of the scrollbars used for tabs and breadcrumbs in the editor title area.
              - default: The default size.
              - large: Increases the size, so it can be grabbed more easily with the mouse.
          '';
        };
        untitled = {
          hint = mkOption {
            type = enum [ "default" "hidden" "text" ];
            default = "default";
            description = ''
              Controls if the untitled hint should be inline text in the editor or a floating button or hidden.
            '';
          };
          labelFormat = mkOption {
            type = enum [ "content" "name" ];
            default = "content";
            description = ''
              Controls the format of the label for an untitled editor.
                - content: The name of the untitled file is derived from the contents of its first line unless it has an associated file path. It will fallback to the name in case the line is empty or contains no word characters.
                - name: The name of the untitled file is not derived from the contents of the file.
            '';
          };
        };
        wrapTabs = mkOption {
          type = bool;
          default = false;
          description = ''
            Controls whether tabs should be wrapped over multiple lines when exceeding available space or whether a scrollbar should appear instead. 
            This value is ignored when `workbench.editor.showTabs` is disabled.
          '';
        };
      };
      editorAssociations = mkOption {
        type = listOf (attrsOf str);
        default = [{ }];
        description = ''
          Configure glob patterns to editors (e.g. `"*.hex": "hexEditor.hexEdit"`). These have precedence over the default behavior.
        '';
      };
      externalUriOpeners = mkOption {
        type = attrsOf str;
        default = { };
        description = ''
          Configure the opener to use for external URIs (http, https).
        '';
      };
      fontAliasing = mkOption {
        type = enum [ "default" "antialiased" "none" "auto" ];
        default = "default";
        description = ''
          Controls font aliasing method in the workbench.
            - default: Sub-pixel font smoothing. On most non-retina displays this will give the sharpest text.
            - antialiased: Smooth the font on the level of the pixel, as opposed to the subpixel. Can make the font appear lighter overall.
            - none: Disables font smoothing. Text will show with jagged sharp edges.
            - auto: Applies `default` or `antialiased` automatically based on the DPI of displays.
        '';
      };
      hover = {
        delay = mkOption {
          type = int;
          default = 500;
          description = ''
            Controls the delay in milliseconds after which the hover is shown for workbench items (ex. some extension provided tree view items).
            Already visible items may require a refresh before reflecting this setting change.
          '';
        };
      };
      iconTheme = mkOption {
        type = nullOr (enum [ "vs-minimal" "vs-seti" ]);
        default = "vs-seti";
        description = ''
          Specifies the file icon theme used in the workbench or 'null' to not show any file icons.
            - null: No file icons
            - vs-minimal
            - vs-seti
        '';
      };
      list = {
        automaticKeyboardNavigation = mkOption {
          type = bool;
          default = true;
          description = ''
            Controls whether keyboard navigation in lists and trees is automatically triggered simply by typing. 
            If set to `false`, keyboard navigation is only triggered when executing the `list.toggleKeyboardNavigation` command, for which you can assign a keyboard shortcut.
          '';
        };
        horizontalScrolling = mkOption {
          type = bool;
          default = false;
          description = ''
            Controls whether lists and trees support horizontal scrolling in the workbench. Warning: turning on this setting has a performance implication.
          '';
        };
        keyboardNavigation = mkOption {
          type = enum [ "simple" "highlight" "filter" ];
          default = "highlight";
          description = ''
            Controls the keyboard navigation style for lists and trees in the workbench. Can be simple, highlight and filter.
              - simple: Simple keyboard navigation focuses elements which match the keyboard input. Matching is done only on prefixes.
              - highlight: Highlight keyboard navigation highlights elements which match the keyboard input. Further up and down navigation will traverse only the highlighted elements.
              - filter: Filter keyboard navigation will filter out and hide all the elements which do not match the keyboard input.
          '';
        };
        multiSelectModifier = mkOption {
          type = enum [ "ctrlCmd" "alt" ];
          default = "ctrlCmd";
          description = ''
            The modifier to be used to add an item in trees and lists to a multi-selection with the mouse (for example in the explorer, open editors and scm view). The 'Open to Side' mouse gestures - if supported - will adapt such that they do not conflict with the multiselect modifier.
              - ctrlCmd: Maps to `Control` on Windows and Linux and to `Command` on macOS.
              - alt: Maps to `Alt` on Windows and Linux and to `Option` on macOS.
          '';
        };
        openMode = mkOption {
          type = enum [ "singleClick" "doubleClick" ];
          default = "singleClick";
          description = ''
            Controls how to open items in trees and lists using the mouse (if supported). 
            Note that some trees and lists might choose to ignore this setting if it is not applicable.
          '';
        };
        smoothScrolling = mkOption {
          type = bool;
          default = false;
          description = ''
            Controls whether lists and trees have smooth scrolling.
          '';
        };
      };
      panel = {
        defaultLocation = mkOption {
          type = enum [ "left" "bottom" "right" ];
          default = "bottom";
          description = ''
            Controls the default location of the panel (terminal, debug console, output, problems). 
            It can either show at the bottom, right, or left of the workbench.
          '';
        };
        opensMaximized = mkOption {
          type = enum [ "always" "never" "preserve" ];
          default = "preserve";
          description = ''
            Controls whether the panel opens maximized. It can either always open maximized, never open maximized, or open to the last state it was in before being closed.
              - always: Always maximize the panel when opening it.
              - never: Never maximize the panel when opening it. The panel will open un-maximized.
              - preserve: Open the panel to the state that it was in, before it was closed.
          '';
        };
      };
      preferredDarkColorTheme = mkOption {
        type = str;
        default = "Default Dark+";
        description = ''
          Specifies the preferred color theme for dark OS appearance when `window.autoDetectColorScheme` is enabled.
        '';
      };
      preferredHighContrastColorTheme = mkOption {
        type = str;
        default = "Default High Contrast";
        description = ''
          Specifies the preferred color theme used in high contrast mode when `window.autoDetectHighContrast` is enabled.
        '';
      };
      preferredLightColorTheme = mkOption {
        type = str;
        default = "Default Light+";
        description = ''
          Specifies the preferred color theme for light OS appearance when `window.autoDetectColorScheme` is enabled.
        '';
      };
      productIconTheme = mkOption {
        type = str;
        default = "Default";
        description = ''
          Specifies the product icon theme used.
            - Default: Default
        '';
      };
      quickOpen = {
        closeOnFocusLost = mkOption {
          type = bool;
          default = true;
          description = ''
            Controls whether Quick Open should close automatically once it loses focus.
          '';
        };
        preserveInput = mkOption {
          type = bool;
          default = false;
          description = ''
            Controls whether the last typed input to Quick Open should be restored when opening it the next time.
          '';
        };
      };
      sash = {
        preserveInput = mkOption {
          type = int;
          default = 300;
          description = ''
            Controls the hover feedback delay in milliseconds of the dragging area in between views/editors.
          '';
        };
        size = mkOption {
          type = int;
          default = 4;
          description = ''
            Controls the feedback area size in pixels of the dragging area in between views/editors.
            Set it to a larger value if you feel it's hard to resize views using the mouse.
          '';
        };
      };
      settings = {
        opensMaximized = mkOption {
          type = enum [ "ui" "json" ];
          default = "json";
          description = ''
            Determines which settings editor to use by default.
              - ui: Use the settings UI editor.
              - json: Use the JSON file editor.
          '';
        };
        enableNaturalLanguageSearch = mkOption {
          type = bool;
          default = true;
          description = ''
            Controls whether to enable the natural language search mode for settings.
            The natural language search is provided by a Microsoft online service.
          '';
        };
        openDefaultKeybindings = mkOption {
          type = bool;
          default = false;
          description = ''
            Controls whether opening keybinding settings also opens an editor showing all default keybindings.
          '';
        };
        openDefaultSettings = mkOption {
          type = bool;
          default = false;
          description = ''
            Controls whether opening settings also opens an editor showing all default settings.
          '';
        };
        settingsSearchTocBehavior = mkOption {
          type = enum [ "hide" "filter" ];
          default = "filter";
          description = ''
            Controls the behavior of the settings editor Table of Contents while searching.
              - hide: Hide the Table of Contents while searching.
              - filter: Filter the Table of Contents to just categories that have matching settings. Clicking a category will filter the results to that category
          '';
        };
        useSplitJSON = mkOption {
          type = bool;
          default = false;
          description = ''
            Controls whether to use the split JSON editor when editing settings as JSON.
          '';
        };
      };
      sideBar = {
        location = mkOption {
          type = enum [ "left" "right" ];
          default = "left";
          description = ''
            Controls the location of the sidebar and activity bar. They can either show on the left or right of the workbench.
          '';
        };
      };
      startupEditor = mkOption {
        type = enum [
          "none"
          "welcomePage"
          "readme"
          "newUntitledFile"
          "welcomePageInEmptyWorkbench"
          "gettingStarted"
          "gettingStartedInEmptyWorkbench"
        ];
        default = "gettingStarted";
        description = ''
          Controls which editor is shown at startup, if none are restored from the previous session.
            - none: Start without an editor.
            - welcomePage: Open the legacy Welcome page.
            - readme: Open the README when opening a folder that contains one, fallback to 'welcomePage' otherwise.
            - newUntitledFile: Open a new untitled file (only applies when opening an empty window).
            - welcomePageInEmptyWorkbench: Open the legacy Welcome page when opening an empty workbench.
            - gettingStarted: Open the new Welcome Page with content to aid in getting started with VS Code and extensions.
            - gettingStartedInEmptyWorkbench: When opening an empty workbench, open the new Welcome Page with content to aid in getting started with VS Code and extensions.
        '';
      };
      statusBar = {
        visible = mkOption {
          type = bool;
          default = true;
          description = ''
            Controls the visibility of the status bar at the bottom of the workbench.
          '';
        };
      };
      tips = {
        enabled = mkOption {
          type = bool;
          default = true;
          description = ''
            When enabled, will show the watermark tips when no editor is open.
          '';
        };
      };
      tree = {
        expandMode = mkOption {
          type = enum [ "singleClick" "doubleClick" ];
          default = "singleClick";
          description = ''
            Controls how tree folders are expanded when clicking the folder names. Note that some trees and lists might choose to ignore this setting if it is not applicable.
          '';
        };
        indent = mkOption {
          type = int;
          default = 8;
          description = ''
            Controls tree indentation in pixels.
          '';
        };
        renderIndentGuides = mkOption {
          type = enum [ "none" "onHover" "always" ];
          default = "onHover";
          description = ''
            Controls whether the tree should render indent guides.
          '';
        };
      };
      view = {
        alwaysShowHeaderActions = mkOption {
          type = bool;
          default = false;
          description = ''
            Controls the visibility of view header actions. 
            View header actions may either be always visible, or only visible when that view is focused or hovered over.
          '';
        };
      };
      welcomePage = {
        walkthroughs = {
          openOnInstall = mkOption {
            type = bool;
            default = true;
            description = ''
              When enabled, an extension's walkthrough will open upon install the extension. 
              Walkthroughs are the items contributed the the 'Getting Started' section of the welcome page.
            '';
          };
        };
      };
    };
    window = {
      autoDetectColorScheme = mkOption {
        type = bool;
        default = false;
        description = ''
          If set, automatically switch to the preferred color theme based on the OS appearance. 
          If the OS appearance is dark, the theme specified at `workbench.preferredDarkColorTheme` is used, for light `workbench.preferredLightColorTheme`.
        '';
      };
      autoDetectHighContrast = mkOption {
        type = bool;
        default = true;
        description = ''
          If enabled, will automatically change to high contrast theme if the OS is using a high contrast theme. 
          The high contrast theme to use is specified by `workbench.preferredHighContrastColorTheme`.
        '';
      };
      clickThroughInactive = mkOption {
        type = bool;
        default = true;
        description = ''
          If enabled, clicking on an inactive window will both activate the window and trigger the element under the mouse if it is clickable.
          If disabled, clicking anywhere on an inactive window will activate it only and a second click is required on the element.
        '';
      };
      closeWhenEmpty = mkOption {
        type = bool;
        default = false;
        description = ''
          Controls whether closing the last editor should also close the window.
          This setting only applies for windows that do not show folders.
        '';
      };
      customMenuBarAltFocus = mkOption {
        type = bool;
        default = true;
        description = ''
          Controls whether the menu bar will be focused by pressing the Alt-key.
          This setting has no effect on toggling the menu bar with the Alt-key.
        '';
      };
      dialogStyle = mkOption {
        type = enum [ "native" "custom" ];
        default = "native";
        description = ''
          Adjust the appearance of dialog windows.
        '';
      };
      doubleClickIconToClose = mkOption {
        type = bool;
        default = false;
        description = ''
          If enabled, double clicking the application icon in the title bar will close the window and the window cannot be dragged by the icon. 
          This setting only has an effect when `window.titleBarStyle` is set to `custom`.
        '';
      };
      nativeFullScreen = mkOption {
        type = bool;
        default = true;
        description = ''
          Controls if native full-screen should be used on macOS. Disable this option to prevent macOS from creating a new space when going full-screen.
        '';
      };
      nativeTabs = mkOption {
        type = bool;
        default = false;
        description = ''
          Enables macOS Sierra window tabs. Note that changes require a full restart to apply and that native tabs will disable a custom title bar style if configured.
        '';
      };
      enableMenuBarMnemonics = mkOption {
        type = bool;
        default = true;
        description = ''
          Controls whether the main menus can be opened via Alt-key shortcuts. 
          Disabling mnemonics allows to bind these Alt-key shortcuts to editor commands instead.
        '';
      };
      menuBarVisibility = mkOption {
        type = enum [ "classic" "visible" "toggle" "hidden" "compact" ];
        default = "classic";
        description = ''
          Control the visibility of the menu bar. A setting of 'toggle' means that the menu bar is hidden and a single press of the Alt key will show it. A setting of 'compact' will move the menu into the sidebar.
            - classic: Menu is displayed at the top of the window and only hidden in full screen mode.
            - visible: Menu is always visible at the top of the window even in full screen mode.
            - toggle: Menu is hidden but can be displayed at the top of the window via the Alt key.
            - hidden: Menu is always hidden.
            - compact: Menu is displayed as a compact button in the sidebar. This value is ignored when `window.titleBarStyle` is `native`.
        '';
      };
      newWindowDimensions = mkOption {
        type = enum [ "default" "inherit" "offset" "maximized" "fullscreen" ];
        default = "default";
        description = ''
          Controls the dimensions of opening a new window when at least one window is already opened. Note that this setting does not have an impact on the first window that is opened. The first window will always restore the size and location as you left it before closing.
            - default: Open new windows in the center of the screen.
            - inherit: Open new windows with same dimension as last active one.
            - offset: Open new windows with same dimension as last active one with an offset position.
            - maximized: Open new windows maximized.
            - fullscreen: Open new windows in full screen mode.
        '';
      };
      openFilesInNewWindow = mkOption {
        type = enum [ "on" "off" "default" ];
        default = "off";
        description = ''
          Controls whether files should open in a new window.
          Note that there can still be cases where this setting is ignored (e.g. when using the `--new-window` or `--reuse-window` command line option).
            - on: Files will open in a new window.
            - off: Files will open in the window with the files' folder open or the last active window.
            - default: Files will open in a new window unless picked from within the application (e.g. via the File menu).
        '';
      };
      openFoldersInNewWindow = mkOption {
        type = enum [ "on" "off" "default" ];
        default = "default";
        description = ''
          Controls whether folders should open in a new window or replace the last active window.
          Note that there can still be cases where this setting is ignored (e.g. when using the `--new-window` or `--reuse-window` command line option).
            - on: Folders will open in a new window.
            - off: Folders will replace the last active window.
            - default: Folders will open in a new window unless a folder is picked from within the application (e.g. via the File menu).
        '';
      };
      openWithoutArgumentsInNewWindow = mkOption {
        type = enum [ "on" "off" ];
        default = "on";
        description = ''
          Controls whether a new empty window should open when starting a second instance without arguments or if the last running instance should get focus.
          Note that there can still be cases where this setting is ignored (e.g. when using the `--new-window` or `--reuse-window` command line option).
            - on: Open a new empty window.
            - off: Focus the last active running instance.
        '';
      };
      restoreFullscreen = mkOption {
        type = bool;
        default = false;
        description = ''
          Controls whether a window should restore to full screen mode if it was exited in full screen mode.
        '';
      };
      restoreWindows = mkOption {
        type = enum [ "preserve" "all" "folders" "one" "none" ];
        default = "all";
        description = ''
          Controls how windows are being reopened after starting for the first time. This setting has no effect when the application is already running.
            - preserve: Always reopen all windows. If a folder or workspace is opened (e.g. from the command line) it opens as a new window unless it was opened before. If files are opened they will open in one of the restored windows.
            - all: Reopen all windows unless a folder, workspace or file is opened (e.g. from the command line).
            - folders: Reopen all windows that had folders or workspaces opened unless a folder, workspace or file is opened (e.g. from the command line).
            - one: Reopen the last active window unless a folder, workspace or file is opened (e.g. from the command line).
            - none: Never reopen a window. Unless a folder or workspace is opened (e.g. from the command line), an empty window will appear.
        '';
      };
      title = mkOption {
        type = str;
        default =
          "\${dirty}\${activeEditorShort}\${separator}\${rootName}\${separator}\${appName}";
        description = ''
          Controls the window title based on the active editor. Variables are substituted based on the context:
            - `$\{activeEditorShort}`: the file name (e.g. myFile.txt).
            - `$\{activeEditorMedium}`: the path of the file relative to the workspace folder (e.g. myFolder/myFileFolder/myFile.txt).
            - `$\{activeEditorLong}`: the full path of the file (e.g. /Users/Development/myFolder/myFileFolder/myFile.txt).
            - `$\{activeFolderShort}`: the name of the folder the file is contained in (e.g. myFileFolder).
            - `$\{activeFolderMedium}`: the path of the folder the file is contained in, relative to the workspace folder (e.g. myFolder/myFileFolder).
            - `$\{activeFolderLong}`: the full path of the folder the file is contained in (e.g. /Users/Development/myFolder/myFileFolder).
            - `$\{folderName}`: name of the workspace folder the file is contained in (e.g. myFolder).
            - `$\{folderPath}`: file path of the workspace folder the file is contained in (e.g. /Users/Development/myFolder).
            - `$\{rootName}`: name of the opened workspace or folder (e.g. myFolder or myWorkspace).
            - `$\{rootPath}`: file path of the opened workspace or folder (e.g. /Users/Development/myWorkspace).
            - `$\{appName}`: e.g. VS Code.
            - `$\{remoteName}`: e.g. SSH
            - `$\{dirty}`: a dirty indicator if the active editor is dirty.
            - `$\{separator}`: a conditional separator (" - ") that only shows when surrounded by variables with values or static text.
        '';
      };
      titleBarStyle = mkOption {
        type = enum [ "native" "custom" ];
        default = "custom";
        description = ''
          Adjust the appearance of the window title bar. On Linux and Windows, this setting also affects the application and context menu appearances.
          Changes require a full restart to apply.
        '';
      };
      titleSeparator = mkOption {
        type = str;
        default = " - ";
        description = ''
          Separator used by `window.title`.
        '';
      };
      zoomLevel = mkOption {
        type = int;
        default = 0;
        description = ''
          Separator used by `window.title`.
        '';
      };
    };
    files = {
      associations = mkOption {
        type = attrsOf str;
        default = { };
        description = ''
          Configure file associations to languages (e.g. `"*.extension": "html"`). These have precedence over the default associations of the languages installed.
        '';
      };
      autoGuessEncoding = mkOption {
        type = bool;
        default = false;
        description = ''
          When enabled, the editor will attempt to guess the character set encoding when opening files.
          This setting can also be configured per language.
        '';
      };
      autoSave = mkOption {
        type = enum [ "off" "afterDelay" "onFocusChange" "onWindowChange" ];
        default = "off";
        description = ''
          Controls auto save of dirty editors.
            - off: A dirty editor is never automatically saved.
            - afterDelay: A dirty editor is automatically saved after the configured `files.autoSaveDelay`.
            - onFocusChange: A dirty editor is automatically saved when the editor loses focus.
            - onWindowChange: A dirty editor is automatically saved when the window loses focus.
        '';
      };
      autoSaveDelay = mkOption {
        type = int;
        default = 1000;
        description = ''
          Controls the delay in ms after which a dirty editor is saved automatically.
          Only applies when `files.autoSave` is set to `afterDelay`.
        '';
      };
      defaultLanguage = mkOption {
        type = str;
        default = "";
        description = ''
          The default language mode that is assigned to new files. 
          If configured to `$\{activeEditorLanguage}`, will use the language mode of the currently active text editor if any.
        '';
      };
      enableTrash = mkOption {
        type = bool;
        default = true;
        description = ''
          Moves files/folders to the OS trash (recycle bin on Windows) when deleting.
          Disabling this will delete files/folders permanently.
        '';
      };
      encoding = mkOption {
        type = enum [
          "utf8"
          "utf8bom"
          "utf16be"
          "utf16le"
          "windows1252"
          "iso88591"
          "iso88593"
          "iso885915"
          "macroman"
          "cp437"
          "windows1256"
          "iso88596"
          "windows1257"
          "iso88594"
          "iso885914"
          "windows1250"
          "iso88592"
          "cp852"
          "windows1251"
          "cp866"
          "iso88595"
          "koi8r"
          "koi8u"
          "iso885913"
          "windows1253"
          "iso88597"
          "windows1255"
          "iso88598"
          "iso885910"
          "iso885916"
          "windows1254"
          "iso88599"
          "windows1258"
          "gbk"
          "gb18030"
          "cp950"
          "big5hkscs"
          "shiftjis"
          "eucjp"
          "eukr"
          "windows874"
          "iso885911"
          "koi8ru"
          "koi8t"
          "gb2312"
          "cp865"
          "cp850"
        ];
        default = "utf8";
        description = ''
          The default character set encoding to use when reading and writing files.
          This setting can also be configured per language.
        '';
      };
      eol = mkOption {
        type = enum [ "\n" "\r\n" "auto" ];
        default = "auto";
        description = ''
          The default end of line character.
            - \n: LF
            - \r\n: CRLF
            - auto: Uses operating system specific end of line character.
        '';
      };
      exclude = mkOption {
        type = attrsOf bool;
        default = {
          "**/.git " = true;
          " * */.svn " = true;
          " * */.hg " = true;
          " * */CVS " = true;
          " * */.DS_Store " = true;
        };
        description = ''
          Configure glob patterns for excluding files and folders. 
          For example, the file Explorer decides which files and folders to show or hide based on this setting. 
          Refer to the `search.exclude` setting to define search specific excludes.
        '';
      };
      hotExit = mkOption {
        type = enum [ "off" "onExit" "onExitAndWindowClose" ];
        default = "onExit";
        description = ''
          Controls whether unsaved files are remembered between sessions, allowing the save prompt when exiting the editor to be skipped.
            - off: Disable hot exit. A prompt will show when attempting to close a window with dirty files.
            - onExit: Hot exit will be triggered when the last window is closed on Windows/Linux or when the `workbench.action.quit` command is triggered (command palette, keybinding, menu). 
              All windows without folders opened will be restored upon next launch. A list of previously opened windows with unsaved files can be accessed via `File > Open Recent > More...`
            - onExitAndWindowClose: Hot exit will be triggered when the last window is closed on Windows/Linux or when the `workbench.action.quit` command is triggered (command palette, keybinding, menu), and also for any window with a folder opened regardless of whether it's the last window. 
              All windows without folders opened will be restored upon next launch. A list of previously opened windows with unsaved files can be accessed via `File > Open Recent > More...`
        '';
      };
      insertFinalNewline = mkOption {
        type = bool;
        default = false;
        description = ''
          When enabled, insert a final new line at the end of the file when saving it.
        '';
      };
      maxMemoryForLargeFilesMB = mkOption {
        type = int;
        default = 4096;
        description = ''
          Controls the memory available to VS Code after restart when trying to open large files. 
          Same effect as specifying `--max-memory=NEWSIZE` on the command line.
        '';
      };
      participants = {
        timeout = mkOption {
          type = int;
          default = 60000;
          description = ''
            Timeout in milliseconds after which file participants for create, rename, and delete are cancelled. Use `0` to disable participants.
          '';
        };
      };
      restoreUndoStack = mkOption {
        type = bool;
        default = true;
        description = ''
          Restore the undo stack when a file is reopened.
        '';
      };
      saveConflictResolution = mkOption {
        type = enum [ "askUser" "overwriteFileOnDisk" ];
        default = "askUser";
        description = ''
          CA save conflict can occur when a file is saved to disk that was changed by another program in the meantime. To prevent data loss, the user is asked to compare the changes in the editor with the version on disk. This setting should only be changed if you frequently encounter save conflict errors and may result in data loss if used without caution.
            - askUser: Will refuse to save and ask for resolving the save conflict manually.
            - overwriteFileOnDisk: Will resolve the save conflict by overwriting the file on disk with the changes in the editor.
        '';
      };
      simpleDialog = {
        restoreUndoStack = mkOption {
          type = bool;
          default = false;
          description = ''
            Enables the simple file dialog. 
            The simple file dialog replaces the system file dialog when enabled.
          '';
        };
      };
      trimFinalNewlines = mkOption {
        type = bool;
        default = false;
        description = ''
          When enabled, will trim all new lines after the final new line at the end of the file when saving it.
        '';
      };
      trimTrailingWhitespace = mkOption {
        type = bool;
        default = false;
        description = ''
          When enabled, will trim trailing whitespace when saving a file.
        '';
      };
      watcherExclude = mkOption {
        type = attrsOf bool;
        default = {
          " * */.git/objects/ * *" = true;
          " * */.git/subtree-cache/ * *" = true;
          " * */node_modules/ * /**" = true;
          "**/.hg/store/* * " = true;
        };
        description = ''
          Configure glob patterns of file paths to exclude from file watching.
          Patterns must match on absolute paths (i.e. prefix with ** or the full path to match properly).
          Changing this setting requires a restart.
          When you experience Code consuming lots of CPU time on startup, you can exclude large folders to reduce the initial load.
        '';
      };
    };
    screencastMode = {
      fontSize = mkOption {
        type = int;
        default = 56;
        description = ''
          Controls the font size (in pixels) of the screencast mode keyboard.
        '';
      };
      keyboardOverlayTimeout = mkOption {
        type = int;
        default = 800;
        description = ''
          Controls how long (in milliseconds) the keyboard overlay is shown in screencast mode.
        '';
      };
      mouseIndicatorColor = mkOption {
        type = str;
        default = "#FF0000";
        description = ''
          Controls the color in hex (#_RGB, #RGBA, #RRGGBB or #RRGGBBAA) of the mouse indicator in screencast mode.
        '';
      };
      mouseIndicatorSize = mkOption {
        type = int;
        default = 20;
        description = ''
          Controls the size (in pixels) of the mouse indicator in screencast mode.
        '';
      };
      onlyKeyboardShortcuts = mkOption {
        type = bool;
        default = false;
        description = ''
          Only show keyboard shortcuts in screencast mode.
        '';
      };
      verticalOffset = mkOption {
        type = int;
        default = 20;
        description = ''
          Controls the vertical offset of the screencast mode overlay from the bottom as a percentage of the workbench height.
        '';
      };
    };
    zenMode = {
      centerLayout = mkOption {
        type = bool;
        default = true;
        description = ''
          Controls whether turning on Zen Mode also centers the layout.
        '';
      };
      fullScreen = mkOption {
        type = bool;
        default = true;
        description = ''
          Controls whether turning on Zen Mode also puts the workbench into full screen mode.
        '';
      };
      hideActivityBar = mkOption {
        type = bool;
        default = true;
        description = ''
          Controls whether turning on Zen Mode also hides the activity bar either at the left or right of the workbench.
        '';
      };
      hideLineNumbers = mkOption {
        type = bool;
        default = true;
        description = ''
          Controls whether turning on Zen Mode also hides the editor line numbers.
        '';
      };
      hideStatusBar = mkOption {
        type = bool;
        default = true;
        description = ''
          Controls whether turning on Zen Mode also hides the status bar at the bottom of the workbench.
        '';
      };
      hideTabs = mkOption {
        type = bool;
        default = true;
        description = ''
          Controls whether turning on Zen Mode also hides workbench tabs.
        '';
      };
      restore = mkOption {
        type = bool;
        default = true;
        description = ''
          Controls whether a window should restore to zen mode if it was exited in zen mode.
        '';
      };
      silentNotifications = mkOption {
        type = bool;
        default = true;
        description = ''
          Controls whether notifications are shown while in zen mode. If true, only error notifications will pop out.
        '';
      };
    };
    explorer = {
      autoReveal = mkOption {
        type = enum [ true false "focusNoScroll" ];
        default = true;
        description = ''
          Controls whether the explorer should automatically reveal and select files when opening them.
            - true: Files will be revealed and selected.
            - false: Files will not be revealed and selected.
            - focusNoScroll: Files will not be scrolled into view, but will still be focused.
        '';
      };
      compactFolders = mkOption {
        type = bool;
        default = true;
        description = ''
          Controls whether the explorer should render folders in a compact form.
          In such a form, single child folders will be compressed in a combined tree element. Useful for Java package structures, for example.
        '';
      };
      confirmDelete = mkOption {
        type = bool;
        default = true;
        description = ''
          Controls whether the explorer should ask for confirmation when deleting a file via the trash.
        '';
      };
      confirmDragAndDrop = mkOption {
        type = bool;
        default = true;
        description = ''
          Controls whether the explorer should automatically reveal and select files when opening them.
            - true: Files will be revealed and selected.
            - false: Files will not be revealed and selected.
            - focusNoScroll: Files will not be scrolled into view, but will still be focused.
        '';
      };
      decorations = {
        badges = mkOption {
          type = bool;
          default = true;
          description = ''
            Controls whether file decorations should use badges.
          '';
        };
        colors = mkOption {
          type = bool;
          default = true;
          description = ''
            Controls whether file decorations should use colors.
          '';
        };
      };
      enableDragAndDrop = mkOption {
        type = bool;
        default = true;
        description = ''
          Controls whether the explorer should allow to move files and folders via drag and drop.
          This setting only effects drag and drop from inside the explorer.
        '';
      };
      incrementalNaming = mkOption {
        type = enum [ "simple" "smart" ];
        default = "simple";
        description = ''
          Controls what naming strategy to use when a giving a new name to a duplicated explorer item on paste.
            - simple: Appends the word "copy" at the end of the duplicated name potentially followed by a number
            - smart: Adds a number at the end of the duplicated name. If some number is already part of the name, tries to increase that number
        '';
      };
      openEditors = {
        sortOrder = mkOption {
          type = enum [ "editorOrder" "alphabetical" ];
          default = "editorOrder";
          description = ''
            Controls the sorting order of editors in the Open Editors pane.
              - editorOrder: Editors are ordered in the same order editor tabs are shown.
              - alphabetical: Editors are ordered in alphabetical order inside each editor group.
          '';
        };
        visible = mkOption {
          type = int;
          default = 9;
          description = ''
            Number of editors shown in the Open Editors pane. Setting this to 0 hides the Open Editors pane.
          '';
        };
      };
      sortOrder = mkOption {
        type = enum [ "default" "mixed" "filesFirst" "type" "modified" ];
        default = "default";
        description = ''
          Controls the property-based sorting of files and folders in the explorer.
            - default: Files and folders are sorted by their names. Folders are displayed before files.
            - mixed: Files and folders are sorted by their names. Files are interwoven with folders.
            - filesFirst: Files and folders are sorted by their names. Files are displayed before folders.
            - type: Files and folders are grouped by extension type then sorted by their names. Folders are displayed before files.
            - modified: Files and folders are sorted by last modified date in descending order. Folders are displayed before files.
        '';
      };
      sortOrderLexicographicOptions = mkOption {
        type = enum [ "default" "upper" "lower" "unicode" ];
        default = "default";
        description = ''
          Controls the lexicographic sorting of file and folder names in the Explorer.
            - default: Uppercase and lowercase names are mixed together.
            - upper: Uppercase names are grouped together before lowercase names.
            - lower: Lowercase names are grouped together before uppercase names.
            - unicode: Names are sorted in unicode order.
        '';
      };
    };
    search = {
      actionsPosition = mkOption {
        type = enum [ "right" "left" ];
        default = "right";
        description = ''
          Controls the positioning of the actionbar on rows in the search view.
            - auto: Position the actionbar to the right when the search view is narrow, and immediately after the content when the search view is wide.
            - right: Always position the actionbar to the right.
        '';
      };
      collapseResults = mkOption {
        type = enum [ "auto" "alwaysCollapse" "alwaysExpand" ];
        default = "alwaysExpand";
        description = ''
          Controls whether the search results will be collapsed or expanded.
            - auto: Files with less than 10 results are expanded. Others are collapsed.
            - alwaysCollapse
            - alwaysExpand
        '';
      };
      exclude = mkOption {
        type = attrsOf bool;
        default = {
          "**/node_modules" = true;
          "**/bower_components" = true;
          "**/*.code-search" = true;
        };
        description = ''
          Configure glob patterns for excluding files and folders in fulltext searches and quick open. 
          Inherits all glob patterns from the `files.exclude` setting.
        '';
      };
      followSymlinks = mkOption {
        type = bool;
        default = true;
        description = ''
          Controls whether to follow symlinks while searching.
        '';
      };
    };
    search = {
      globalFindClipboard = mkOption {
        type = bool;
        default = true;
        description = ''
          Controls whether the search view should read or modify the shared find clipboard on macOS.
        '';
      };
      mode = mkOption {
        type = enum [ "view" "reuseEditor" "newEditor" ];
        default = "view";
        description = ''
          Controls where new `Search: Find in Files` and `Find in Folder` operations occur: either in the sidebar's search view, or in a search editor
            - view: Search in the search view, either in the panel or sidebar.
            - reuseEditor: Search in an existing search editor if present, otherwise in a new search editor.
            - newEditor: Search in a new search editor.
        '';
      };
      quickOpen = {
        history = {
          filterSortOrder = mkOption {
            type = enum [ "default" "recency" ];
            default = "default";
            description = ''
              Controls sorting order of editor history in quick open when filtering.
                - default: History entries are sorted by relevance based on the filter value used. More relevant entries appear first.
                - recency: History entries are sorted by recency. More recently opened entries appear first.
            '';
          };
        };
        includeHistory = mkOption {
          type = bool;
          default = true;
          description = ''
            Whether to include results from recently opened files in the file results for Quick Open.
          '';
        };
        includeSymbols = mkOption {
          type = bool;
          default = false;
          description = ''
            Whether to include results from a global symbol search in the file results for Quick Open.
          '';
        };
      };
      searchEditor = {
        defaultNumberOfContextLines = mkOption {
          type = int;
          default = 1;
          description = ''
            The default number of surrounding context lines to use when creating new Search Editors.
            If using `search.searchEditor.reusePriorSearchConfiguration`, this can be set to `null` (empty) to use the prior Search Editor's configuration.
          '';
        };
        doubleClickBehaviour = mkOption {
          type = enum [ "selectWord" "goToLocation" "openLocationToSide" ];
          default = "goToLocation";
          description = ''
            Configure effect of double clicking a result in a search editor.
              - selectWord: Double clicking selects the word under the cursor.
              - goToLocation: Double clicking opens the result in the active editor group.
              - openLocationToSide: Double clicking opens the result in the editor group to the side, creating one if it does not yet exist.
          '';
        };
        reusePriorSearchConfiguration = mkOption {
          type = bool;
          default = false;
          description = ''
            When enabled, new Search Editors will reuse the includes, excludes, and flags of the previously opened Search Editor.
          '';
        };
      };
      searchOnType = mkOption {
        type = bool;
        default = true;
        description = ''
          Search all files as you type.
        '';
      };
      searchOnTypeDebouncePeriod = mkOption {
        type = int;
        default = 300;
        description = ''
          When `search.searchOnType` is enabled, controls the timeout in milliseconds between a character being typed and the search starting.
          Has no effect when `search.searchOnType` is disabled.
        '';
      };
      seedOnFocus = mkOption {
        type = bool;
        default = false;
        description = ''
          Update the search query to the editor's selected text when focusing the search view. 
          This happens either on click or when triggering the `workbench.views.search.focus` command.
        '';
      };
      seedWithNearestWord = mkOption {
        type = bool;
        default = false;
        description = ''
          Enable seeding search from the word nearest the cursor when the active editor has no selection.
        '';
      };
      showLineNumbers = mkOption {
        type = bool;
        default = false;
        description = ''
          Controls whether to show line numbers for search results.
        '';
      };
      smartCase = mkOption {
        type = bool;
        default = false;
        description = ''
          Search case-insensitively if the pattern is all lowercase, otherwise, search case-sensitively.
        '';
      };
      sortOrder = mkOption {
        type = enum [
          "default"
          "fileNames"
          "type"
          "modified"
          "countDescending"
          "countAscending"
        ];
        default = "default";
        description = ''
          Controls sorting order of search results.
            - default: Results are sorted by folder and file names, in alphabetical order.
            - fileNames: Results are sorted by file names ignoring folder order, in alphabetical order.
            - type: Results are sorted by file extensions, in alphabetical order.
            - modified: Results are sorted by file last modified date, in descending order.
            - countDescending: Results are sorted by count per file, in descending order.
            - countAscending: Results are sorted by count per file, in ascending order.
        '';
      };
      useGlobalIgnoreFiles = mkOption {
        type = bool;
        default = false;
        description = ''
          Controls whether to use global `.gitignore` and `.ignore` files when searching for files.
        '';
      };
      useIgnoreFiles = mkOption {
        type = bool;
        default = true;
        description = ''
          Controls whether to use `.gitignore` and `.ignore` files when searching for files.
        '';
      };
      useReplacePreview = mkOption {
        type = bool;
        default = true;
        description = ''
          Controls whether to open Replace Preview when selecting or replacing a match.
        '';
      };
    };
    http = {
      proxy = mkOption {
        type = str;
        default = "";
        description = ''
          Controls whether to open Replace Preview when selecting or replacing a match.
        '';
      };
      proxyAuthorization = mkOption {
        type = nullOr str;
        default = "";
        description = ''
          Controls whether to open Replace Preview when selecting or replacing a match.
        '';
      };
      proxyStrictSSL = mkOption {
        type = bool;
        default = true;
        description = ''
          Controls whether the proxy server certificate should be verified against the list of supplied CAs.
        '';
      };
      proxySupport = mkOption {
        type = enum [ "off" "on" "fallback" "override" ];
        default = "override";
        description = ''
          Use the proxy support for extensions.
            - off: Disable proxy support for extensions.
            - on: Enable proxy support for extensions.
            - fallback: Enable proxy support for extensions, fall back to request options, when no proxy found.
            - override: Enable proxy support for extensions, override request options.
        '';
      };
      systemCertificates = mkOption {
        type = bool;
        default = true;
        description = ''
          Controls whether CA certificates should be loaded from the OS. 
          (On Windows and macOS, a reload of the window is required after turning this off.)
        '';
      };
    };
    keyboard = {
      dispatch = mkOption {
        type = enum [ "code" "keyCode" ];
        default = "code";
        description = ''
          Controls the dispatching logic for key presses to use either `code` (recommended) or `keyCode`.
        '';
      };
      touchbar = {
        enabled = mkOption {
          type = bool;
          default = true;
          description = ''
            Enables the macOS touchbar buttons on the keyboard if available.
          '';
        };
        ignored = mkOption {
          type = listOf str;
          default = [ ];
          description = ''
            A set of identifiers for entries in the touchbar that should not show up (for example `workbench.action.navigateBack`).
          '';
        };
      };
    };
    update = {
      enableWindowsBackgroundUpdates = mkOption {
        type = bool;
        default = true;
        description = ''
          Enable to download and install new VS Code versions in the background on Windows.
        '';
      };
      mode = mkOption {
        type = enum [ "none" "manual" "start" "default" ];
        default = "default";
        description = ''
          Enable to download and install new VS Code versions in the background on Windows.
        '';
      };
      showReleaseNotes = mkOption {
        type = bool;
        default = true;
        description = ''
          Show Release Notes after an update. 
          The Release Notes are fetched from a Microsoft online service.
        '';
      };
    };
    comments = {
      openPanel = mkOption {
        type = enum [
          "neverOpen"
          "openOnSessionStart"
          "openOnSessionStartWithComments"
        ];
        default = "openOnSessionStartWithComments";
        description = ''
          Controls when the comments panel should open.
        '';
      };
    };

    debug = {
      allowBreakpointsEverywhere = mkOption {
        type = bool;
        default = true;
        description = ''
          Allow setting breakpoints in any file.
        '';
      };
      console = {
        closeOnEnd = mkOption {
          type = bool;
          default = false;
          description = ''
            Controls if the debug console should be automatically closed when the debug session ends.
          '';
        };
        collapseIdenticalLines = mkOption {
          type = bool;
          default = true;
          description = ''
            Controls if the debug console should collapse identical lines and show a number of occurrences with a badge.
          '';
        };
        fontFamily = mkOption {
          type = str;
          default = "default";
          description = ''
            Controls the font family in the debug console.
          '';
        };
        fontSize = mkOption {
          type = int;
          default = 14;
          description = ''
            Controls the font size in pixels in the debug console.
          '';
        };
        historySuggestions = mkOption {
          type = bool;
          default = true;
          description = ''
            Controls if the debug console should suggest previously typed input.
          '';
        };
        lineHeight = mkOption {
          type = int;
          default = 0;
          description = ''
            Controls the line height in pixels in the debug console. Use 0 to compute the line height from the font size.
          '';
        };
        wordWrap = mkOption {
          type = bool;
          default = true;
          description = ''
            Controls if the lines should wrap in the debug console.
          '';
        };
      };
      focusWindowOnBreak = mkOption {
        type = bool;
        default = true;
        description = ''
          Controls whether the workbench window should be focused when the debugger breaks.
        '';
      };
      inlineValues = mkOption {
        type = enum [ true false "auto" ];
        default = true;
        description = ''
          Show variable values inline in editor while debugging.
            - true: Always show variable values inline in editor while debugging.
            - false: Never show variable values inline in editor while debugging.
            - auto: Show variable values inline in editor while debugging when the language supports inline value locations.
        '';
      };
      internalConsoleOptions = mkOption {
        type =
          enum [ "neverOpen" "openOnFirstSessionStart" "openOnSessionStart" ];
        default = "openOnFirstSessionStart";
        description = ''
          Controls when the internal debug console should open.
        '';
      };
      onTaskErrors = mkOption {
        type = enum [ "debugAnyway" "showErrors" "prompt" "auto" ];
        default = "prompt";
        description = ''
          Controls what to do when errors are encountered after running a preLaunchTask.
            - debugAnyway: Ignore task errors and start debugging.
            - showErrors: Show the Problems view and do not start debugging.
            - prompt: Prompt user.
            - abort: Cancel debugging.
        '';
      };
      openDebug = mkOption {
        type = enum [ "neverOpen" "openOnSessionStart" "openOnFirstSessionStart" "openOnDebugBreak" ];
        default = "openOnDebugBreak";
        description = ''
          Automatically open the explorer view at the end of a debug session.
        '';
      };
      saveBeforeStart = mkOption {
        type = enum [
          "allEditorsInActiveGroup"
          "nonUntitledEditorsInActiveGroup"
          "none"
        ];
        default = "allEditorsInActiveGroup";
        description = ''
          Controls what editors to save before starting a debug session.
            - allEditorsInActiveGroup: Save all editors in the active group before starting a debug session.
            - nonUntitledEditorsInActiveGroup: Save all editors in the active group except untitled ones before starting a debug session.
            - none: Don't save any editors before starting a debug session.
        '';
      };
      showBreakpointsInOverviewRuler = mkOption {
        type = bool;
        default = false;
        description = ''
          Controls whether breakpoints should be shown in the overview ruler.
        '';
      };
      showInlineBreakpointCandidates = mkOption {
        type = bool;
        default = true;
        description = ''
          Controls whether inline breakpoints candidate decorations should be shown in the editor while debugging.
        '';
      };
      showInStatusBar = mkOption {
        type = enum [ "never" "always" "onFirstSessionStart" ];
        default = "onFirstSessionStart";
        description = ''
          Controls when the debug status bar should be visible.
            - never: Never show debug in status bar
            - always: Always show debug in status bar
            - onFirstSessionStart: Show debug in status bar only after debug was started for the first time
        '';
      };
      showSubSessionsInToolBar = mkOption {
        type = bool;
        default = false;
        description = ''
          Controls whether the debug sub-sessions are shown in the debug tool bar.
          When this setting is false the stop command on a sub-session will also stop the parent session.
        '';
      };
      clearBeforeReusing = mkOption {
        type = bool;
        default = false;
        description = ''
          Before starting a new debug session in an integrated or external terminal, clear the terminal.
        '';
      };
      toolBarLocation = mkOption {
        type = enum [ "floating" "docked" "hidden" ];
        default = "floating";
        description = ''
          Controls the location of the debug toolbar.
          Either `floating` in all views, `docked` in the debug view, or `hidden`.
        '';
      };
    };
    launch = mkOption {
      type = attrsOf (listOf str);
      default = {
        configurations = [ ];
        compounds = [ ];
      };
      description = ''
        Global debug launch configuration.
        Should be used as an alternative to 'launch.json' that is shared across workspaces.
      '';
    };
    html = {
      autoClosingTags = mkOption {
        type = bool;
        default = true;
        description = ''
          Enable/disable autoclosing of HTML tags.
        '';
      };
      customData = mkOption {
        type = listOf str;
        default = [ ];
        description = ''
          A list of relative file paths pointing to JSON files following the custom data format.
          VS Code loads custom data on startup to enhance its HTML support for the custom HTML tags, attributes and attribute values you specify in the JSON files.
          The file paths are relative to workspace and only workspace folder settings are considered.
        '';
      };
      format = {
        contentUnformatted = mkOption {
          type = str;
          default = "pre,code,textarea";
          description = ''
            List of tags, comma separated, where the content shouldn't be reformatted. `null` defaults to the `pre` tag.
          '';
        };
        enable = mkOption {
          type = bool;
          default = true;
          description = ''
            Enable/disable default HTML formatter.
          '';
        };
        endWithNewline = mkOption {
          type = bool;
          default = false;
          description = ''
            End with a newline.
          '';
        };
        extraLiners = mkOption {
          type = str;
          default = "head, body, /html";
          description = ''
            List of tags, comma separated, that should have an extra newline before them. `null` defaults to `"head, body, /html"`.
          '';
        };
        indentHandlebars = mkOption {
          type = bool;
          default = false;
          description = ''
            Format and indent ``.
          '';
        };
        indentInnerHtml = mkOption {
          type = bool;
          default = false;
          description = ''
            Indent `<head>` and `<body>` sections.
          '';
        };
        maxPreserveNewLines = mkOption {
          type = nullOr int;
          default = null;
          description = ''
            Maximum number of line breaks to be preserved in one chunk.
            Use `null` for unlimited.
          '';
        };
        preserveNewLines = mkOption {
          type = bool;
          default = true;
          description = ''
            Controls whether existing line breaks before elements should be preserved.
            Only works before elements, not inside tags or for text.
          '';
        };
        templating = mkOption {
          type = bool;
          default = false;
          description = ''
            Honor django, erb, handlebars and php templating language tags.
          '';
        };
        unformatted = mkOption {
          type = str;
          default = "wbr";
          description = ''
            List of tags, comma separated, that shouldn't be reformatted.
          '';
        };
        unformattedContentDelimiter = mkOption {
          type = str;
          default = "";
          description = ''
            Keep text content together between this string.
          '';
        };
        wrapAttributes = mkOption {
          type = enum [
            "auto"
            "force"
            "force-aligned"
            "force-expand-multiline"
            "aligned-multiple"
            "preserve"
            "preserve-aligned"
          ];
          default = "auto";
          description = ''
            Wrap attributes.
              - auto: Wrap attributes only when line length is exceeded.
              - force: Wrap each attribute except first.
              - force-aligned: Wrap each attribute except first and keep aligned.
              - force-expand-multiline: Wrap each attribute.
              - aligned-multiple: Wrap when line length is exceeded, align attributes vertically.
              - preserve: Preserve wrapping of attributes.
              - preserve-aligned: Preserve wrapping of attributes but align.
          '';
        };
        wrapAttributesIndentSize = mkOption {
          type = nullOr int;
          default = null;
          description = ''
            Alignment size when using 'force aligned' and 'aligned multiple' in `html.format.wrapAttributes` or `null` to use the default indent size.
          '';
        };
        wrapLineLength = mkOption {
          type = int;
          default = 0;
          description = ''
            Maximum amount of characters per line (0 = disable).
          '';
        };
      };
      hover = {
        documentation = mkOption {
          type = bool;
          default = true;
          description = ''
            Show tag and attribute documentation in hover.
          '';
        };
        references = mkOption {
          type = bool;
          default = true;
          description = ''
            Show references to MDN in hover.
          '';
        };
      };
      suggest = {
        html5 = mkOption {
          type = bool;
          default = true;
          description = ''
            Controls whether the built-in HTML language support suggests HTML5 tags, properties and values.
          '';
        };
      };
      trace = {
        server = mkOption {
          type = enum [ "off" "messages" "verbose" ];
          default = "off";
          description = ''
            Traces the communication between VS Code and the HTML language server.
          '';
        };
      };
      validate = {
        scripts = mkOption {
          type = bool;
          default = true;
          description = ''
            Controls whether the built-in HTML language support validates embedded scripts.
          '';
        };
        styles = mkOption {
          type = bool;
          default = true;
          description = ''
            Controls whether the built-in HTML language support validates embedded styles.
          '';
        };
      };
    };
    json = {
      format = {
        enable = mkOption {
          type = bool;
          default = true;
          description = ''
            Enable/disable default JSON formatter
          '';
        };
      };
      maxItemsComputed = mkOption {
        type = int;
        default = 5000;
        description = ''
          The maximum number of outline symbols and folding regions computed (limited for performance reasons).
        '';
      };
      schemaDownload = {
        enable = mkOption {
          type = bool;
          default = true;
          description = ''
            When enabled, JSON schemas can be fetched from http and https locations.
          '';
        };
      };
      schemas = mkOption {
        type = listOf str;
        default = [ ];
        description = ''
          Associate schemas to JSON files in the current project.
        '';
      };
      trace = {
        server = mkOption {
          type = enum [ "off" "messages" "verbose" ];
          default = "off";
          description = ''
            Traces the communication between VS Code and the JSON language server.
          '';
        };
      };
    };
    markdown = {
      links = {
        openLocation = mkOption {
          type = enum [ "currentGroup" "beside" ];
          default = "currentGroup";
          description = ''
            Controls where links in Markdown files should be opened.
              - currentGroup: Open links in the active editor group.
              - beside: Open links beside the active editor.
          '';
        };
      };
      preview = {
        breaks = mkOption {
          type = bool;
          default = false;
          description = ''
            Sets how line-breaks are rendered in the Markdown preview.
            Setting it to 'true' creates a <br> for newlines inside paragraphs.
          '';
        };
        doubleClickToSwitchToEditor = mkOption {
          type = bool;
          default = true;
          description = ''
            Double click in the Markdown preview to switch to the editor.
          '';
        };
        fontFamily = mkOption {
          type = str;
          default =
            "-apple-system, BlinkMacSystemFont, 'Segoe WPC', 'Segoe UI', system-ui, 'Ubuntu', 'Droid Sans', sans-serif";
          description = ''
            Controls the font family used in the Markdown preview.
          '';
        };
        fontSize = mkOption {
          type = int;
          default = 14;
          description = ''
            Controls the font size in pixels used in the Markdown preview.
          '';
        };
        lineHeight = mkOption {
          type = float;
          default = 1.6;
          description = ''
            Controls the line height used in the Markdown preview.
            This number is relative to the font size.
          '';
        };
        linkify = mkOption {
          type = bool;
          default = true;
          description = ''
            Enable or disable conversion of URL-like text to links in the Markdown preview.
          '';
        };
        markEditorSelection = mkOption {
          type = bool;
          default = true;
          description = ''
            Mark the current editor selection in the Markdown preview.
          '';
        };
        openLocation = mkOption {
          type = enum [ "inPreview" "inEditor" ];
          default = "inPreview";
          description = ''
            Controls how links to other Markdown files in the Markdown preview should be opened.
              - inPreview: Try to open links in the Markdown preview.
              - inEditor: Try to open links in the editor.
          '';
        };
        scrollEditorWithPreview = mkOption {
          type = bool;
          default = true;
          description = ''
            When a Markdown preview is scrolled, update the view of the editor.
          '';
        };
        scrollPreviewWithEditor = mkOption {
          type = bool;
          default = true;
          description = ''
            When a Markdown editor is scrolled, update the view of the preview.
          '';
        };
        typographer = mkOption {
          type = bool;
          default = false;
          description = ''
            Enable or disable some language-neutral replacement and quotes beautification in the Markdown preview.
          '';
        };
      };
      styles = mkOption {
        type = listOf str;
        default = [ ];
        description = ''
          A list of URLs or local paths to CSS style sheets to use from the Markdown preview.
          Relative paths are interpreted relative to the folder open in the explorer.
          If there is no open folder, they are interpreted relative to the location of the Markdown file. All '\' need to be written as '\\'.
        '';
      };
      trace = mkOption {
        type = enum [ "off" "verbose" ];
        default = "off";
        description = ''
          Enable debug logging for the Markdown extension.
        '';
      };
    };
    php = {
      suggest = {
        basic = mkOption {
          type = bool;
          default = true;
          description = ''
            Controls whether the built-in PHP language suggestions are enabled.
            The support suggests PHP globals and variables.
          '';
        };
      };
      validate = {
        enable = mkOption {
          type = bool;
          default = true;
          description = ''
            Enable/disable built-in PHP validation.
          '';
        };
        executablePath = mkOption {
          type = nullOr str;
          default = null;
          description = ''
            Points to the PHP executable.
          '';
        };
        run = mkOption {
          type = enum [ "onSave" "onType" ];
          default = "onSave";
          description = ''
            Whether the linter is run on save or on type.
          '';
        };
      };
    };
    javascript = {
      autoClosingTags = mkOption {
        type = bool;
        default = true;
        description = ''
          Enable/disable automatic closing of JSX tags.
        '';
      };
      format = {
        enable = mkOption {
          type = bool;
          default = true;
          description = ''
            Enable/disable default JavaScript formatter.
          '';
        };
        insertSpaceAfterCommaDelimiter = mkOption {
          type = bool;
          default = true;
          description = ''
            Defines space handling after a comma delimiter.
          '';
        };
        insertSpaceAfterConstructor = mkOption {
          type = bool;
          default = false;
          description = ''
            Defines space handling after the constructor keyword.
          '';
        };
        insertSpaceAfterFunctionKeywordForAnonymousFunctions = mkOption {
          type = bool;
          default = true;
          description = ''
            Defines space handling after function keyword for anonymous functions.
          '';
        };
        insertSpaceAfterKeywordsInControlFlowStatements = mkOption {
          type = bool;
          default = true;
          description = ''
            Defines space handling after keywords in a control flow statement.
          '';
        };
        insertSpaceAfterOpeningAndBeforeClosingEmptyBraces = mkOption {
          type = bool;
          default = true;
          description = ''
            Defines space handling after opening and before closing empty braces.
          '';
        };
        insertSpaceAfterOpeningAndBeforeClosingJsxExpressionBraces = mkOption {
          type = bool;
          default = false;
          description = ''
            Defines space handling after opening and before closing JSX expression braces.
          '';
        };
        insertSpaceAfterOpeningAndBeforeClosingNonemptyBraces = mkOption {
          type = bool;
          default = true;
          description = ''
            Defines space handling after opening and before closing non-empty braces.
          '';
        };
        insertSpaceAfterOpeningAndBeforeClosingNonemptyBrackets = mkOption {
          type = bool;
          default = false;
          description = ''
            Defines space handling after opening and before closing non-empty brackets.
          '';
        };
        insertSpaceAfterOpeningAndBeforeClosingNonemptyParenthesis = mkOption {
          type = bool;
          default = false;
          description = ''
            Defines space handling after opening and before closing non-empty parenthesis.
          '';
        };
        insertSpaceAfterOpeningAndBeforeClosingTemplateStringBraces = mkOption {
          type = bool;
          default = false;
          description = ''
            Defines space handling after opening and before closing template string braces.
          '';
        };
        insertSpaceAfterSemicolonInForStatements = mkOption {
          type = bool;
          default = true;
          description = ''
            Defines space handling after a semicolon in a for statement.
          '';
        };
        insertSpaceBeforeAndAfterBinaryOperators = mkOption {
          type = bool;
          default = true;
          description = ''
            Defines space handling after a binary operator.
          '';
        };
        insertSpaceBeforeFunctionParenthesis = mkOption {
          type = bool;
          default = false;
          description = ''
            Defines space handling before function argument parentheses.
          '';
        };
        placeOpenBraceOnNewLineForControlBlocks = mkOption {
          type = bool;
          default = false;
          description = ''
            Defines whether an open brace is put onto a new line for control blocks or not.
          '';
        };
        placeOpenBraceOnNewLineForFunctions = mkOption {
          type = bool;
          default = false;
          description = ''
            Defines whether an open brace is put onto a new line for functions or not.
          '';
        };
        semicolons = mkOption {
          type = enum [ "ignore" "insert" "remove" ];
          default = "ignore";
          description = ''
            Defines handling of optional semicolons. Requires using TypeScript 3.7 or newer in the workspace.
              - ignore: Don't insert or remove any semicolons.
              - insert: Insert semicolons at statement ends.
              - remove: Remove unnecessary semicolons.
          '';
        };
      };
      preferences = {
        importModuleSpecifier = mkOption {
          type =
            enum [ "shortest" "relative" "non-relative" "project-relative" ];
          default = "shortest";
          description = ''
            Preferred path style for auto imports.
              - shortest: Prefers a non-relative import only if one is available that has fewer path segments than a relative import.
              - relative: Prefers a relative path to the imported file location.
              - non-relative: Prefers a non-relative import based on the `baseUrl` or `paths` configured in your `jsconfig.json` / `tsconfig.json`.
              - project-relative: Prefers a non-relative import only if the relative import path would leave the package or project directory. Requires using TypeScript 4.2+ in the workspace.
          '';
        };
        importModuleSpecifierEnding = mkOption {
          type = enum [ "auto" "minimal" "index" "js" ];
          default = "auto";
          description = ''
            Preferred path ending for auto imports.
              - auto: Use project settings to select a default.
              - minimal: Shorten `./component/index.js` to `./component`.
              - index: Shorten `./component/index.js` to `./component/index`.
              - js: Do not shorten path endings; include the `.js` extension.
          '';
        };
        quoteStyle = mkOption {
          type = enum [ "single" "double" "auto" ];
          default = "auto";
          description = ''
            Preferred quote style to use for quick fixes: `single` quotes, `double` quotes, or `auto` infer quote type from existing imports.
          '';
        };
        renameShorthandProperties = mkOption {
          type = bool;
          default = true;
          description = ''
            The setting 'typescript.preferences.renameShorthandProperties' has been deprecated in favor of 'typescript.preferences.useAliasesForRenames'
            Enable/disable introducing aliases for object shorthand properties during renames. Requires using TypeScript 3.4 or newer in the workspace.
          '';
        };
        useAliasesForRenames = mkOption {
          type = bool;
          default = true;
          description = ''
            Enable/disable introducing aliases for object shorthand properties during renames. Requires using TypeScript 3.4 or newer in the workspace.
          '';
        };
      };
      referencesCodeLens = {
        enabled = mkOption {
          type = bool;
          default = false;
          description = ''
            Enable/disable references CodeLens in JavaScript files.
          '';
        };
        showOnAllFunctions = mkOption {
          type = bool;
          default = false;
          description = ''
            Enable/disable references CodeLens on all functions in JavaScript files.
          '';
        };
      };
      suggest = {
        autoImports = mkOption {
          type = bool;
          default = true;
          description = ''
            Enable/disable auto import suggestions.
          '';
        };
        completeFunctionCalls = mkOption {
          type = bool;
          default = false;
          description = ''
            Complete functions with their parameter signature.
          '';
        };
        completeJSDocs = mkOption {
          type = bool;
          default = true;
          description = ''
            Enable/disable suggestion to complete JSDoc comments.
          '';
        };
        enabled = mkOption {
          type = bool;
          default = true;
          description = ''
            Enabled/disable autocomplete suggestions.
          '';
        };
        includeAutomaticOptionalChainCompletions = mkOption {
          type = bool;
          default = true;
          description = ''
            Enable/disable showing completions on potentially undefined values that insert an optional chain call.
            Requires TS 3.7+ and strict null checks to be enabled.
          '';
        };
        includeCompletionsForImportStatements = mkOption {
          type = bool;
          default = true;
          description = ''
            Enable/disable auto-import-style completions on partially-typed import statements.
            Requires using TypeScript 4.3+ in the workspace.
          '';
        };
        jsdoc = {
          generateReturns = mkOption {
            type = bool;
            default = true;
            description = ''
              Enable/disable generating `@return` annotations for JSDoc templates.
              Requires using TypeScript 4.2+ in the workspace.
            '';
          };
        };
        names = mkOption {
          type = bool;
          default = true;
          description = ''
            Enable/disable including unique names from the file in JavaScript suggestions.
            Note that name suggestions are always disabled in JavaScript code that is semantically checked using `@ts-check` or `checkJs`.
          '';
        };
        paths = mkOption {
          type = bool;
          default = true;
          description = ''
            Enable/disable suggestions for paths in import statements and require calls.
          '';
        };
      };
      suggestionActions = {
        enabled = mkOption {
          type = bool;
          default = true;
          description = ''
            Enable/disable suggestion diagnostics for JavaScript files in the editor.
          '';
        };
      };
      updateImportsOnFileMove = {
        enabled = mkOption {
          type = enum [ "prompt" "always" "never" ];
          default = "prompt";
          description = ''
            Enable/disable automatic updating of import paths when you rename or move a file in VS Code.
              - prompt: Prompt on each rename.
              - always: Always update paths automatically.
              - never: Never rename paths and don't prompt.
          '';
        };
      };
      validate = {
        enable = mkOption {
          type = bool;
          default = true;
          description = ''
            Enable/disable JavaScript validation.
          '';
        };
      };
    };
    "js/ts" = {
      implicitProjectConfig = {
        checkJs = mkOption {
          type = bool;
          default = false;
          description = ''
            Enable/disable semantic checking of JavaScript files.
            Existing `jsconfig.json` or `tsconfig.json` files override this setting.
          '';
        };
        strictFunctionTypes = mkOption {
          type = bool;
          default = true;
          description = ''
            Enable/disable strict function types in JavaScript and TypeScript files that are not part of a project.
            Existing `jsconfig.json` or `tsconfig.json` files override this setting.
          '';
        };
        strictNullChecks = mkOption {
          type = bool;
          default = false;
          description = ''
            Enable/disable strict null checks in JavaScript and TypeScript files that are not part of a project.
            Existing `jsconfig.json` or `tsconfig.json` files override this setting.
          '';
        };
      };
    };
    typescript = {
      autoClosingTags = mkOption {
        type = bool;
        default = true;
        description = ''
          Enable/disable automatic closing of JSX tags.
        '';
      };
      check = {
        npmIsInstalled = mkOption {
          type = bool;
          default = true;
          description = ''
            Check if npm is installed for Automatic Type Acquisition.
          '';
        };
      };
      disableAutomaticTypeAcquisition = mkOption {
        type = bool;
        default = false;
        description = ''
          Disables automatic type acquisition.
          Automatic type acquisition fetches `@types` packages from npm to improve IntelliSense for external libraries.
        '';
      };
      enablePromptUseWorkspaceTsdk = mkOption {
        type = bool;
        default = false;
        description = ''
          Enables prompting of users to use the TypeScript version configured in the workspace for Intellisense.
        '';
      };
      format = {
        enablePromptUseWorkspaceTsdk = mkOption {
          type = bool;
          default = true;
          description = ''
            Enable/disable default TypeScript formatter.
          '';
        };
        insertSpaceAfterCommaDelimiter = mkOption {
          type = bool;
          default = true;
          description = ''
            Defines space handling after a comma delimiter.
          '';
        };
        insertSpaceAfterConstructor = mkOption {
          type = bool;
          default = false;
          description = ''
            Defines space handling after the constructor keyword.
          '';
        };
        insertSpaceAfterFunctionKeywordForAnonymousFunctions = mkOption {
          type = bool;
          default = true;
          description = ''
            Defines space handling after the function keyword for anonymous functions.
          '';
        };
        insertSpaceAfterKeywordsInControlFlowStatements = mkOption {
          type = bool;
          default = true;
          description = ''
            Defines space handling after keywords in a control flow statement.
          '';
        };
        insertSpaceAfterOpeningAndBeforeClosingEmptyBraces = mkOption {
          type = bool;
          default = true;
          description = ''
            Defines space handling after opening and before closing empty braces.
          '';
        };
        insertSpaceAfterOpeningAndBeforeClosingJsxExpressionBraces = mkOption {
          type = bool;
          default = false;
          description = ''
            Defines space handling after opening and before closing JSX expression braces.
          '';
        };
        insertSpaceAfterOpeningAndBeforeClosingNonemptyBraces = mkOption {
          type = bool;
          default = false;
          description = ''
            Defines space handling after opening and before closing non-empty braces.
          '';
        };
        insertSpaceAfterOpeningAndBeforeClosingNonemptyBrackets = mkOption {
          type = bool;
          default = false;
          description = ''
            Defines space handling after opening and before closing non-empty brackets.
          '';
        };
        insertSpaceAfterOpeningAndBeforeClosingNonemptyParenthesis = mkOption {
          type = bool;
          default = false;
          description = ''
            Defines space handling after opening and before closing non-empty parenthesis.
          '';
        };
        insertSpaceAfterOpeningAndBeforeClosingTemplateStringBraces = mkOption {
          type = bool;
          default = false;
          description = ''
            Defines space handling after opening and before closing template string braces.
          '';
        };
        insertSpaceAfterSemicolonInForStatements = mkOption {
          type = bool;
          default = true;
          description = ''
            Defines space handling after a semicolon in a for statement.
          '';
        };
        insertSpaceAfterTypeAssertion = mkOption {
          type = bool;
          default = false;
          description = ''
            Defines space handling after type assertions in TypeScript.
          '';
        };
        insertSpaceBeforeAndAfterBinaryOperators = mkOption {
          type = bool;
          default = true;
          description = ''
            Defines space handling after a binary operator.
          '';
        };
        insertSpaceBeforeFunctionParenthesis = mkOption {
          type = bool;
          default = false;
          description = ''
            Defines space handling before function argument parentheses.
          '';
        };
        placeOpenBraceOnNewLineForControlBlocks = mkOption {
          type = bool;
          default = false;
          description = ''
            Defines whether an open brace is put onto a new line for control blocks or not.
          '';
        };
        placeOpenBraceOnNewLineForFunctions = mkOption {
          type = bool;
          default = false;
          description = ''
            Defines whether an open brace is put onto a new line for functions or not.
          '';
        };
        semicolons = mkOption {
          type = enum [ "ignore" "insert" "remove" ];
          default = "ignore";
          description = ''
            Defines handling of optional semicolons. Requires using TypeScript 3.7 or newer in the workspace.
              - ignore: Don't insert or remove any semicolons.
              - insert: Insert semicolons at statement ends.
              - remove: Remove unnecessary semicolons.
          '';
        };
      };
      implementationsCodeLens = {
        enabled = mkOption {
          type = bool;
          default = false;
          description = ''
            Enable/disable implementations CodeLens.
            This CodeLens shows the implementers of an interface.
          '';
        };
      };
      locale = mkOption {
        type = nullOr str;
        default = null;
        description = ''
          Sets the locale used to report JavaScript and TypeScript errors.
          Default of `null` uses VS Code's locale.
        '';
      };
      npm = mkOption {
        type = nullOr str;
        default = null;
        description = ''
          Specifies the path to the npm executable used for Automatic Type Acquisition.
        '';
      };
      preferences = {
        importModuleSpecifier = mkOption {
          type =
            enum [ "shortest" "relative" "non-relative" "project-relative" ];
          default = "shortest";
          description = ''
            Preferred path style for auto imports.
              - shortest: Prefers a non-relative import only if one is available that has fewer path segments than a relative import.
              - relative: Prefers a relative path to the imported file location.
              - non-relative: Prefers a non-relative import based on the `baseUrl` or `paths` configured in your `jsconfig.json` / `tsconfig.json`.
              - project-relative: Prefers a non-relative import only if the relative import path would leave the package or project directory. Requires using TypeScript 4.2+ in the workspace.
          '';
        };
        importModuleSpecifierEnding = mkOption {
          type = enum [ "auto" "minimal" "index" "js" ];
          default = "auto";
          description = ''
            Preferred path ending for auto imports.
              - auto: Use project settings to select a default.
              - minimal: Shorten `./component/index.js` to `./component`.
              - index: Shorten `./component/index.js` to `./component/index`.
              - js: Do not shorten path endings; include the `.js` extension.
          '';
        };
        includePackageJsonAutoImports = mkOption {
          type = enum [ "auto" "on" "off" ];
          default = "auto";
          description = ''
            Enable/disable searching `package.json` dependencies for available auto imports.
              - auto: Search dependencies based on estimated performance impact.
              - on: Always search dependencies.
              - off: Never search dependencies.
          '';
        };
        quoteStyle = mkOption {
          type = enum [ "single" "double" "auto" ];
          default = "auto";
          description = ''
            Preferred quote style to use for quick fixes: `single` quotes, `double` quotes, or `auto` infer quote type from existing imports.
          '';
        };
        useAliasesForRenames = mkOption {
          type = bool;
          default = true;
          description = ''
            Enable/disable introducing aliases for object shorthand properties during renames.
            Requires using TypeScript 3.4 or newer in the workspace.
          '';
        };
      };
      referencesCodeLens = {
        enabled = mkOption {
          type = bool;
          default = false;
          description = ''
            Enable/disable references CodeLens in TypeScript files.
          '';
        };
        showOnAllFunctions = mkOption {
          type = bool;
          default = false;
          description = ''
            Enable/disable references CodeLens on all functions in TypeScript files.
          '';
        };
      };
      reportStyleChecksAsWarnings = mkOption {
        type = bool;
        default = true;
        description = ''
          Report style checks as warnings.
        '';
      };
      suggest = {
        autoImports = mkOption {
          type = bool;
          default = true;
          description = ''
            Enable/disable auto import suggestions.
          '';
        };
        completeFunctionCalls = mkOption {
          type = bool;
          default = false;
          description = ''
            Complete functions with their parameter signature.
          '';
        };
        completeJSDocs = mkOption {
          type = bool;
          default = true;
          description = ''
            Enable/disable suggestion to complete JSDoc comments.
          '';
        };
        enabled = mkOption {
          type = bool;
          default = true;
          description = ''
            Enabled/disable autocomplete suggestions.
          '';
        };
        includeAutomaticOptionalChainCompletions = mkOption {
          type = bool;
          default = true;
          description = ''
            Enable/disable showing completions on potentially undefined values that insert an optional chain call.
            Requires TS 3.7+ and strict null checks to be enabled.
          '';
        };
        includeCompletionsForImportStatements = mkOption {
          type = bool;
          default = true;
          description = ''
            Enable/disable auto-import-style completions on partially-typed import statements.
            Requires using TypeScript 4.3+ in the workspace.
          '';
        };
        includeCompletionsWithSnippetText = mkOption {
          type = bool;
          default = true;
          description = ''
            Enable/disable snippet completions from TS Server.
            Requires using TypeScript 4.3+ in the workspace.
          '';
        };
        jsdoc = {
          generateReturns = mkOption {
            type = bool;
            default = true;
            description = ''
              Enable/disable generating `@return` annotations for JSDoc templates.
              Requires using TypeScript 4.2+ in the workspace.
            '';
          };
        };
        paths = mkOption {
          type = bool;
          default = true;
          description = ''
            Enable/disable suggestions for paths in import statements and require calls.
          '';
        };
      };
      suggestionActions = {
        enabled = mkOption {
          type = bool;
          default = true;
          description = ''
            Enable/disable suggestion diagnostics for TypeScript files in the editor.
          '';
        };
      };
      tsc = {
        autoDetect = mkOption {
          type = enum [ "on" "off" "build" "watch" ];
          default = "on";
          description = ''
            Controls auto detection of tsc tasks.
              - on: Create both build and watch tasks.
              - off: Disable this feature.
              - build: Only create single run compile tasks.
              - watch: Only create compile and watch tasks.
          '';
        };
      };
      tsdk = mkOption {
        type = nullOr str;
        default = null;
        description = ''
          Specifies the folder path to the tsserver and `lib*.d.ts` files under a TypeScript install to use for IntelliSense, for example: `./node_modules/typescript/lib`.
            - When specified as a user setting, the TypeScript version from `typescript.tsdk` automatically replaces the built-in TypeScript version.
            - When specified as a workspace setting, `typescript.tsdk` allows you to switch to use that workspace version of TypeScript for IntelliSense with the `TypeScript: Select TypeScript version` command.
        '';
      };
      tsserver = {
        enableTracing = mkOption {
          type = bool;
          default = false;
          description = ''
            Enables tracing TS server performance to a directory.
            These trace files can be used to diagnose TS Server performance issues. The log may contain file paths, source code, and other potentially sensitive information from your project.
          '';
        };
        log = mkOption {
          type = enum [ "off" "terse" "normal" "verbose" ];
          default = "off";
          description = ''
            Enables logging of the TS server to a file. This log can be used to diagnose TS Server issues.
            The log may contain file paths, source code, and other potentially sensitive information from your project.
          '';
        };
        maxTsServerMemory = mkOption {
          type = int;
          default = 3072;
          description = ''
            The maximum amount of memory (in MB) to allocate to the TypeScript server process.
          '';
        };
        pluginPaths = mkOption {
          type = listOf str;
          default = [ ];
          description = ''
            Additional paths to discover TypeScript Language Service plugins.
          '';
        };
        trace = mkOption {
          type = enum [ "off" "message" "verbose" ];
          default = "off";
          description = ''
            Enables tracing of messages sent to the TS server.
            This trace can be used to diagnose TS Server issues.
            The trace may contain file paths, source code, and other potentially sensitive information from your project.
          '';
        };
        useSeparateSyntaxServer = mkOption {
          type = bool;
          default = true;
          description = ''
            Enable/disable spawning a separate TypeScript server that can more quickly respond to syntax related operations, such as calculating folding or computing document symbols.
            Requires using TypeScript 3.4.0 or newer in the workspace.
          '';
        };
        watchOptions = mkOption {
          type = attrsOf str;
          default = { };
          description = ''
            Configure which watching strategies should be used to keep track of files and directories.
            Requires using TypeScript 3.8+ in the workspace.
          '';
        };
      };
      updateImportsOnFileMove = {
        enabled = mkOption {
          type = enum [ "prompt" "always" "never" ];
          default = "prompt";
          description = ''
            Enable/disable automatic updating of import paths when you rename or move a file in VS Code.
              - prompt: Prompt on each rename.
              - always: Always update paths automatically.
              - never: Never rename paths and don't prompt.
          '';
        };
      };
      validate = {
        enable = mkOption {
          type = bool;
          default = true;
          description = ''
            Enable/disable TypeScript validation.
          '';
        };
      };
      workspaceSymbols = {
        enabled = mkOption {
          type = enum [ "allOpenProjects" "currentProject" ];
          default = "allOpenProjects";
          description = ''
            Controls which files are searched by go to symbol in workspace.
              - allOpenProjects: Search all open JavaScript or TypeScript projects for symbols. Requires using TypeScript 3.9 or newer in the workspace.
              - currentProject: Only search for symbols in the current JavaScript or TypeScript project.
          '';
        };
      };
    };
    css = {
      completion = {
        completePropertyWithSemicolon = mkOption {
          type = bool;
          default = true;
          description = ''
            Insert semicolon at end of line when completing CSS properties.
          '';
        };
        triggerPropertyValueCompletion = mkOption {
          type = bool;
          default = true;
          description = ''
            By default, VS Code triggers property value completion after selecting a CSS property.
            Use this setting to disable this behavior.
          '';
        };
      };
      triggerPropertyValueCompletion = mkOption {
        type = listOf str;
        default = [ ];
        description = ''
          A list of relative file paths pointing to JSON files following the custom data format.
          VS Code loads custom data on startup to enhance its CSS support for the custom CSS properties, at directives, pseudo classes and pseudo elements you specify in the JSON files.
          The file paths are relative to workspace and only workspace folder settings are considered.
        '';
      };
      hover = {
        documentation = mkOption {
          type = bool;
          default = true;
          description = ''
            Show tag and attribute documentation in CSS hovers.
          '';
        };
        references = mkOption {
          type = bool;
          default = true;
          description = ''
            Show references to MDN in CSS hovers.
          '';
        };
      };
      lint = {
        argumentsInColorFunction = mkOption {
          type = enum [ "ignore" "warning" "error" ];
          default = "error";
          description = ''
            Invalid number of parameters.
          '';
        };
        boxModel = mkOption {
          type = enum [ "ignore" "warning" "error" ];
          default = "ignore";
          description = ''
            Do not use `width` or `height` when using `padding` or `border`.
          '';
        };
        compatibleVendorPrefixes = mkOption {
          type = enum [ "ignore" "warning" "error" ];
          default = "ignore";
          description = ''
            When using a vendor-specific prefix make sure to also include all other vendor-specific properties.
          '';
        };
        duplicateProperties = mkOption {
          type = enum [ "ignore" "warning" "error" ];
          default = "ignore";
          description = ''
            Do not use duplicate style definitions.
          '';
        };
        emptyRules = mkOption {
          type = enum [ "ignore" "warning" "error" ];
          default = "ignore";
          description = ''
            Do not use empty rulesets.
          '';
        };
        float = mkOption {
          type = enum [ "ignore" "warning" "error" ];
          default = "ignore";
          description = ''
            Avoid using `float`.
            Floats lead to fragile CSS that is easy to break if one aspect of the layout changes.
          '';
        };
        fontFaceProperties = mkOption {
          type = enum [ "ignore" "warning" "error" ];
          default = "warning";
          description = ''
            `@font-face` rule must define `src` and `font-family` properties.
          '';
        };
        hexColorLength = mkOption {
          type = enum [ "ignore" "warning" "error" ];
          default = "error";
          description = ''
            Hex colors must consist of three or six hex numbers.
          '';
        };
        idSelector = mkOption {
          type = enum [ "ignore" "warning" "error" ];
          default = "ignore";
          description = ''
            Selectors should not contain IDs because these rules are too tightly coupled with the HTML.
          '';
        };
        ieHack = mkOption {
          type = enum [ "ignore" "warning" "error" ];
          default = "ignore";
          description = ''
            IE hacks are only necessary when supporting IE7 and older.
          '';
        };
        important = mkOption {
          type = enum [ "ignore" "warning" "error" ];
          default = "ignore";
          description = ''
            Avoid using `!important`.
            It is an indication that the specificity of the entire CSS has gotten out of control and needs to be refactored.
          '';
        };
        importStatement = mkOption {
          type = enum [ "ignore" "warning" "error" ];
          default = "ignore";
          description = ''
            Import statements do not load in parallel.
          '';
        };
        propertyIgnoredDueToDisplay = mkOption {
          type = enum [ "ignore" "warning" "error" ];
          default = "warning";
          description = ''
            Property is ignored due to the display.
            E.g. with `display: inline`, the `width`, `height`, `margin-top`, `margin-bottom`, and `float` properties have no effect.
          '';
        };
        universalSelector = mkOption {
          type = enum [ "ignore" "warning" "error" ];
          default = "ignore";
          description = ''
            The universal selector (`*`) is known to be slow.
          '';
        };
        unknownAtRules = mkOption {
          type = enum [ "ignore" "warning" "error" ];
          default = "warning";
          description = ''
            Unknown at-rule.
          '';
        };
        unknownProperties = mkOption {
          type = enum [ "ignore" "warning" "error" ];
          default = "warning";
          description = ''
            Unknown property.
          '';
        };
        unknownVendorSpecificProperties = mkOption {
          type = enum [ "ignore" "warning" "error" ];
          default = "ignore";
          description = ''
            Unknown vendor specific property.
          '';
        };
        validProperties = mkOption {
          type = listOf str;
          default = [ ];
          description = ''
            A list of properties that are not validated against the `unknownProperties` rule.
          '';
        };
        vendorPrefix = mkOption {
          type = enum [ "ignore" "warning" "error" ];
          default = "warning";
          description = ''
            When using a vendor-specific prefix, also include the standard property.
          '';
        };
        zeroUnits = mkOption {
          type = enum [ "ignore" "warning" "error" ];
          default = "ignore";
          description = ''
            No unit for zero needed.
          '';
        };
      };
      trace = {
        server = mkOption {
          type = enum [ "off" "messages" "verbose" ];
          default = "off";
          description = ''
            Traces the communication between VS Code and the CSS language server.
          '';
        };
      };
      validate = mkOption {
        type = bool;
        default = true;
        description = ''
          Enables or disables all validations.
        '';
      };
    };
    less = {
      completion = {
        completePropertyWithSemicolon = mkOption {
          type = bool;
          default = true;
          description = ''
            Insert semicolon at end of line when completing CSS properties.
          '';
        };
        triggerPropertyValueCompletion = mkOption {
          type = bool;
          default = true;
          description = ''
            By default, VS Code triggers property value completion after selecting a CSS property.
            Use this setting to disable this behavior.
          '';
        };
      };
      triggerPropertyValueCompletion = mkOption {
        type = listOf str;
        default = [ ];
        description = ''
          A list of relative file paths pointing to JSON files following the custom data format.
          VS Code loads custom data on startup to enhance its CSS support for the custom CSS properties, at directives, pseudo classes and pseudo elements you specify in the JSON files.
          The file paths are relative to workspace and only workspace folder settings are considered.
        '';
      };
      hover = {
        documentation = mkOption {
          type = bool;
          default = true;
          description = ''
            Show tag and attribute documentation in LESS hovers.
          '';
        };
        references = mkOption {
          type = bool;
          default = true;
          description = ''
            Show references to MDN in LESS hovers.
          '';
        };
      };
      lint = {
        argumentsInColorFunction = mkOption {
          type = enum [ "ignore" "warning" "error" ];
          default = "error";
          description = ''
            Invalid number of parameters.
          '';
        };
        boxModel = mkOption {
          type = enum [ "ignore" "warning" "error" ];
          default = "ignore";
          description = ''
            Do not use `width` or `height` when using `padding` or `border`.
          '';
        };
        compatibleVendorPrefixes = mkOption {
          type = enum [ "ignore" "warning" "error" ];
          default = "ignore";
          description = ''
            When using a vendor-specific prefix make sure to also include all other vendor-specific properties.
          '';
        };
        duplicateProperties = mkOption {
          type = enum [ "ignore" "warning" "error" ];
          default = "ignore";
          description = ''
            Do not use duplicate style definitions.
          '';
        };
        emptyRules = mkOption {
          type = enum [ "ignore" "warning" "error" ];
          default = "ignore";
          description = ''
            Do not use empty rulesets.
          '';
        };
        float = mkOption {
          type = enum [ "ignore" "warning" "error" ];
          default = "ignore";
          description = ''
            Avoid using `float`.
            Floats lead to fragile LESS that is easy to break if one aspect of the layout changes.
          '';
        };
        fontFaceProperties = mkOption {
          type = enum [ "ignore" "warning" "error" ];
          default = "warning";
          description = ''
            `@font-face` rule must define `src` and `font-family` properties.
          '';
        };
        hexColorLength = mkOption {
          type = enum [ "ignore" "warning" "error" ];
          default = "error";
          description = ''
            Hex colors must consist of three or six hex numbers.
          '';
        };
        idSelector = mkOption {
          type = enum [ "ignore" "warning" "error" ];
          default = "ignore";
          description = ''
            Selectors should not contain IDs because these rules are too tightly coupled with the HTML.
          '';
        };
        ieHack = mkOption {
          type = enum [ "ignore" "warning" "error" ];
          default = "ignore";
          description = ''
            IE hacks are only necessary when supporting IE7 and older.
          '';
        };
        important = mkOption {
          type = enum [ "ignore" "warning" "error" ];
          default = "ignore";
          description = ''
            Avoid using `!important`.
            It is an indication that the specificity of the entire LESS has gotten out of control and needs to be refactored.
          '';
        };
        importStatement = mkOption {
          type = enum [ "ignore" "warning" "error" ];
          default = "ignore";
          description = ''
            Import statements do not load in parallel.
          '';
        };
        propertyIgnoredDueToDisplay = mkOption {
          type = enum [ "ignore" "warning" "error" ];
          default = "warning";
          description = ''
            Property is ignored due to the display.
            E.g. with `display: inline`, the `width`, `height`, `margin-top`, `margin-bottom`, and `float` properties have no effect.
          '';
        };
        universalSelector = mkOption {
          type = enum [ "ignore" "warning" "error" ];
          default = "ignore";
          description = ''
            The universal selector (`*`) is known to be slow.
          '';
        };
        unknownAtRules = mkOption {
          type = enum [ "ignore" "warning" "error" ];
          default = "warning";
          description = ''
            Unknown at-rule.
          '';
        };
        unknownProperties = mkOption {
          type = enum [ "ignore" "warning" "error" ];
          default = "warning";
          description = ''
            Unknown property.
          '';
        };
        unknownVendorSpecificProperties = mkOption {
          type = enum [ "ignore" "warning" "error" ];
          default = "ignore";
          description = ''
            Unknown vendor specific property.
          '';
        };
        validProperties = mkOption {
          type = listOf str;
          default = [ ];
          description = ''
            A list of properties that are not validated against the `unknownProperties` rule.
          '';
        };
        vendorPrefix = mkOption {
          type = enum [ "ignore" "warning" "error" ];
          default = "warning";
          description = ''
            When using a vendor-specific prefix, also include the standard property.
          '';
        };
        zeroUnits = mkOption {
          type = enum [ "ignore" "warning" "error" ];
          default = "ignore";
          description = ''
            No unit for zero needed.
          '';
        };
      };
      trace = {
        server = mkOption {
          type = enum [ "off" "messages" "verbose" ];
          default = "off";
          description = ''
            Traces the communication between VS Code and the LESS language server.
          '';
        };
      };
      validate = mkOption {
        type = bool;
        default = true;
        description = ''
          Enables or disables all validations.
        '';
      };
    };
    scss = {
      completion = {
        completePropertyWithSemicolon = mkOption {
          type = bool;
          default = true;
          description = ''
            Insert semicolon at end of line when completing CSS properties.
          '';
        };
        triggerPropertyValueCompletion = mkOption {
          type = bool;
          default = true;
          description = ''
            By default, VS Code triggers property value completion after selecting a CSS property.
            Use this setting to disable this behavior.
          '';
        };
      };
      triggerPropertyValueCompletion = mkOption {
        type = listOf str;
        default = [ ];
        description = ''
          A list of relative file paths pointing to JSON files following the custom data format.
          VS Code loads custom data on startup to enhance its CSS support for the custom CSS properties, at directives, pseudo classes and pseudo elements you specify in the JSON files.
          The file paths are relative to workspace and only workspace folder settings are considered.
        '';
      };
      hover = {
        documentation = mkOption {
          type = bool;
          default = true;
          description = ''
            Show tag and attribute documentation in SCSS hovers.
          '';
        };
        references = mkOption {
          type = bool;
          default = true;
          description = ''
            Show references to MDN in SCSS hovers.
          '';
        };
      };
      lint = {
        argumentsInColorFunction = mkOption {
          type = enum [ "ignore" "warning" "error" ];
          default = "error";
          description = ''
            Invalid number of parameters.
          '';
        };
        boxModel = mkOption {
          type = enum [ "ignore" "warning" "error" ];
          default = "ignore";
          description = ''
            Do not use `width` or `height` when using `padding` or `border`.
          '';
        };
        compatibleVendorPrefixes = mkOption {
          type = enum [ "ignore" "warning" "error" ];
          default = "ignore";
          description = ''
            When using a vendor-specific prefix make sure to also include all other vendor-specific properties.
          '';
        };
        duplicateProperties = mkOption {
          type = enum [ "ignore" "warning" "error" ];
          default = "ignore";
          description = ''
            Do not use duplicate style definitions.
          '';
        };
        emptyRules = mkOption {
          type = enum [ "ignore" "warning" "error" ];
          default = "ignore";
          description = ''
            Do not use empty rulesets.
          '';
        };
        float = mkOption {
          type = enum [ "ignore" "warning" "error" ];
          default = "ignore";
          description = ''
            Avoid using `float`.
            Floats lead to fragile SCSS that is easy to break if one aspect of the layout changes.
          '';
        };
        fontFaceProperties = mkOption {
          type = enum [ "ignore" "warning" "error" ];
          default = "warning";
          description = ''
            `@font-face` rule must define `src` and `font-family` properties.
          '';
        };
        hexColorLength = mkOption {
          type = enum [ "ignore" "warning" "error" ];
          default = "error";
          description = ''
            Hex colors must consist of three or six hex numbers.
          '';
        };
        idSelector = mkOption {
          type = enum [ "ignore" "warning" "error" ];
          default = "ignore";
          description = ''
            Selectors should not contain IDs because these rules are too tightly coupled with the HTML.
          '';
        };
        ieHack = mkOption {
          type = enum [ "ignore" "warning" "error" ];
          default = "ignore";
          description = ''
            IE hacks are only necessary when supporting IE7 and older.
          '';
        };
        important = mkOption {
          type = enum [ "ignore" "warning" "error" ];
          default = "ignore";
          description = ''
            Avoid using `!important`.
            It is an indication that the specificity of the entire SCSS has gotten out of control and needs to be refactored.
          '';
        };
        importStatement = mkOption {
          type = enum [ "ignore" "warning" "error" ];
          default = "ignore";
          description = ''
            Import statements do not load in parallel.
          '';
        };
        propertyIgnoredDueToDisplay = mkOption {
          type = enum [ "ignore" "warning" "error" ];
          default = "warning";
          description = ''
            Property is ignored due to the display.
            E.g. with `display: inline`, the `width`, `height`, `margin-top`, `margin-bottom`, and `float` properties have no effect.
          '';
        };
        universalSelector = mkOption {
          type = enum [ "ignore" "warning" "error" ];
          default = "ignore";
          description = ''
            The universal selector (`*`) is known to be slow.
          '';
        };
        unknownAtRules = mkOption {
          type = enum [ "ignore" "warning" "error" ];
          default = "warning";
          description = ''
            Unknown at-rule.
          '';
        };
        unknownProperties = mkOption {
          type = enum [ "ignore" "warning" "error" ];
          default = "warning";
          description = ''
            Unknown property.
          '';
        };
        unknownVendorSpecificProperties = mkOption {
          type = enum [ "ignore" "warning" "error" ];
          default = "ignore";
          description = ''
            Unknown vendor specific property.
          '';
        };
        validProperties = mkOption {
          type = listOf str;
          default = [ ];
          description = ''
            A list of properties that are not validated against the `unknownProperties` rule.
          '';
        };
        vendorPrefix = mkOption {
          type = enum [ "ignore" "warning" "error" ];
          default = "warning";
          description = ''
            When using a vendor-specific prefix, also include the standard property.
          '';
        };
        zeroUnits = mkOption {
          type = enum [ "ignore" "warning" "error" ];
          default = "ignore";
          description = ''
            No unit for zero needed.
          '';
        };
      };
      trace = {
        server = mkOption {
          type = enum [ "off" "messages" "verbose" ];
          default = "off";
          description = ''
            Traces the communication between VS Code and the SCSS language server.
          '';
        };
      };
      validate = mkOption {
        type = bool;
        default = true;
        description = ''
          Enables or disables all validations.
        '';
      };
    };
    extensions = {
      autoCheckUpdates = mkOption {
        type = bool;
        default = true;
        description = ''
          When enabled, automatically checks extensions for updates.
          If an extension has an update, it is marked as outdated in the Extensions view. The updates are fetched from a Microsoft online service.
        '';
      };
      autoUpdate = mkOption {
        type = enum [ true false "onlyEnabledExtensions" ];
        default = true;
        description = ''
          Controls the automatic update behavior of extensions. The updates are fetched from a Microsoft online service.
            - true: Download and install updates automatically for all extensions.
            - onlyEnabledExtensions: Download and install updates automatically only for enabled extensions. Disabled extensions will not be updated automatically.
            - false: Extensions are not automatically updated.
        '';
      };
      closeExtensionDetailsOnViewChange = mkOption {
        type = bool;
        default = false;
        description = ''
          When enabled, editors with extension details will be automatically closed upon navigating away from the Extensions View.
        '';
      };
      confirmedUriHandlerExtensionIds = mkOption {
        type = listOf str;
        default = [ ];
        description = ''
          When an extension is listed here, a confirmation prompt will not be shown when that extension handles a URI.
        '';
      };
      ignoreRecommendations = mkOption {
        type = bool;
        default = false;
        description = ''
          When enabled, the notifications for extension recommendations will not be shown.
        '';
      };
      supportUntrustedWorkspaces = mkOption {
        type = attrsOf bool;
        default = { };
        description = ''
          Override the untrusted workspace support of an extension.
          Extensions using `true` will always be enabled.
          Extensions using `limited` will always be enabled, and the extension will hide functionality that requires trust.
          Extensions using `false` will only be enabled only when the workspace is trusted.
        '';
      };
      supportVirtualWorkspaces = mkOption {
        type = attrsOf bool;
        default = { "pub.name" = false; };
        description = ''
          Override the virtual workspaces support of an extension.
        '';
      };
    };
    output = {
      smartScroll = {
        enabled = mkOption {
          type = bool;
          default = true;
          description = ''
            Enable/disable the ability of smart scrolling in the output view.
            Smart scrolling allows you to lock scrolling automatically when you click in the output view and unlocks when you click in the last line.
          '';
        };
      };
    };
    settingsSync = {
      ignoredExtensions = mkOption {
        type = listOf str;
        default = [ ];
        description = ''
          List of extensions to be ignored while synchronizing.
          The identifier of an extension is always `$\{publisher}.$\{name}`. For example: `vscode.csharp`.
        '';
      };
      ignoredSettings = mkOption {
        type = listOf str;
        default = [ ];
        description = ''
          Configure settings to be ignored while synchronizing.
        '';
      };
      keybindingsPerPlatform = mkOption {
        type = bool;
        default = true;
        description = ''
          Synchronize keybindings for each platform.
        '';
      };
    };
  };
}

/* // Notebooks

  // When enabled notebook breadcrumbs contain code cells.
  "notebook.breadcrumbs.showCodeCells": true,

  // Control whether to render the focus indicator as cell borders or a highlight bar on the left gutter
  "notebook.cellFocusIndicator": "border",

  // Where the cell toolbar should be shown, or whether it should be hidden.
  "notebook.cellToolbarLocation": {
  "default": "right"
  },

  // Whether the cell toolbar should appear on hover or click.
  "notebook.cellToolbarVisibility": "click",

  // Control whether the notebook editor should be rendered in a compact form.
  "notebook.compactView": true,

  // Control whether outputs action should be rendered in the output toolbar.
  "notebook.consolidatedOutputButton": true,

  // Control whether extra actions are shown in a dropdown next to the run button.
  "notebook.consolidatedRunButton": true,

  // Whether to use the enhanced text diff editor for notebook.
  "notebook.diff.enablePreview": true,

  // Hide Metadata Differences
  "notebook.diff.ignoreMetadata": false,

  // Hide Outputs Differences
  "notebook.diff.ignoreOutputs": false,

  // Priority list for output mime types
  "notebook.displayOrder": [],

  // Control whether the notebook editor should allow moving cells through drag and drop.
  "notebook.dragAndDropEnabled": true,

  // Settings for code editors used in notebooks. This can be used to customize most editor.* settings.
  "notebook.editorOptionsCustomizations": {},

  // Enable/disable using the new extensible Markdown renderer.
  "notebook.experimental.useMarkdownRenderer": true,

  // Control whether to render a global toolbar inside the notebook editor.
  "notebook.globalToolbar": false,

  // Control where the insert cell actions should be rendered.
  "notebook.insertToolbarLocation": "both",

  // Controls the display of line numbers in the cell editor.
  "notebook.lineNumbers": "off",

  // When enabled cursor can navigate to the next/previous cell when the current cursor in the cell editor is at the first/last line.
  "notebook.navigation.allowNavigateToSurroundingCells": true,

  // When enabled notebook outline shows code cells.
  "notebook.outline.showCodeCells": false,

  // Whether the cell status bar should be shown.
  //  - hidden: The cell Status bar is always hidden.
  //  - visible: The cell Status bar is always visible.
  //  - visibleAfterExecute: The cell Status bar is hidden until the cell has executed. Then it becomes visible to show the execution status.
  "notebook.showCellStatusBar": true,

  // Controls when the folding controls are shown.
  "notebook.showFoldingControls": "always",

  // Whether to use separate undo/redo stack for each cell.
  "notebook.undoRedoPerCell": false,

  // Terminal

  // Customizes what kind of terminal to launch.
  //  - integrated: Use VS Code's integrated terminal.
  //  - external: Use the configured external terminal.
  "terminal.explorerKind": "integrated",

  // External Terminal

  // Customizes which terminal to run on Linux.
  "terminal.external.linuxExec": "xterm",

  // Customizes which terminal application to run on macOS.
  "terminal.external.osxExec": "Terminal.app",

  // Customizes which terminal to run on Windows.
  "terminal.external.windowsExec": "C:\\Windows\\System32\\cmd.exe",

  // Integrated Terminal

  // Whether or not to allow chord keybindings in the terminal. Note that when this is true and the keystroke results in a chord it will bypass `terminal.integrated.commandsToSkipShell`, setting this to false is particularly useful when you want ctrl+k to go to your shell (not VS Code).
  "terminal.integrated.allowChords": true,

  // Whether to allow menubar mnemonics (eg. alt+f) to trigger the open the menubar. Note that this will cause all alt keystrokes to skip the shell when true. This does nothing on macOS.
  "terminal.integrated.allowMnemonics": false,

  // If enabled, alt/option + click will reposition the prompt cursor to underneath the mouse when `editor.multiCursorModifier` is set to `'alt'` (the default value). This may not work reliably depending on your shell.
  "terminal.integrated.altClickMovesCursor": true,

  // A path that when set will override `terminal.integrated.shell.linux` and ignore `shellArgs` values for automation-related terminal usage like tasks and debug.
  "terminal.integrated.automationShell.linux": null,

  // A path that when set will override `terminal.integrated.shell.osx` and ignore `shellArgs` values for automation-related terminal usage like tasks and debug.
  "terminal.integrated.automationShell.osx": null,

  // A path that when set will override `terminal.integrated.shell.windows` and ignore `shellArgs` values for automation-related terminal usage like tasks and debug.
  "terminal.integrated.automationShell.windows": null,

  // The number of milliseconds to show the bell within a terminal tab when triggered.
  "terminal.integrated.bellDuration": 1000,

  // A set of command IDs whose keybindings will not be sent to the shell but instead always be handled by VS Code. This allows keybindings that would normally be consumed by the shell to act instead the same as when the terminal is not focused, for example `Ctrl+P` to launch Quick Open.
  "terminal.integrated.commandsToSkipShell": [],

  // Controls whether to confirm on exit if there are active terminal sessions.
  "terminal.integrated.confirmOnExit": false,

  // Controls whether text selected in the terminal will be copied to the clipboard.
  "terminal.integrated.copyOnSelection": false,

  // Controls whether the terminal cursor blinks.
  "terminal.integrated.cursorBlinking": false,

  // Controls the style of terminal cursor.
  "terminal.integrated.cursorStyle": "block",

  // Controls the width of the cursor when `terminal.integrated.cursorStyle` is set to `line`.
  "terminal.integrated.cursorWidth": 1,

  // An explicit start path where the terminal will be launched, this is used as the current working directory (cwd) for the shell process. This may be particularly useful in workspace settings if the root directory is not a convenient cwd.
  "terminal.integrated.cwd": "",

  // The default profile used on Linux. This setting will currently be ignored if either `terminal.integrated.shell.linux` or `terminal.integrated.shellArgs.linux` are set.
  "terminal.integrated.defaultProfile.linux": null,

  // The default profile used on macOS. This setting will currently be ignored if either `terminal.integrated.shell.osx` or `terminal.integrated.shellArgs.osx` are set.
  "terminal.integrated.defaultProfile.osx": null,

  // The default profile used on Windows. This setting will currently be ignored if either `terminal.integrated.shell.windows#` or `#terminal.integrated.shellArgs.windows` are set.
  "terminal.integrated.defaultProfile.windows": null,

  // Controls whether to detect and set the `$LANG` environment variable to a UTF-8 compliant option since VS Code's terminal only supports UTF-8 encoded data coming from the shell.
  //  - auto: Set the `$LANG` environment variable if the existing variable does not exist or it does not end in `'.UTF-8'`.
  //  - off: Do not set the `$LANG` environment variable.
  //  - on: Always set the `$LANG` environment variable.
  "terminal.integrated.detectLocale": "auto",

  // Controls whether bold text in the terminal will always use the "bright" ANSI color variant.
  "terminal.integrated.drawBoldTextInBrightColors": true,

  // Controls whether the terminal bell is enabled, this shows up as a visual bell next to the terminal's name.
  "terminal.integrated.enableBell": false,

  // Whether to enable file links in the terminal. Links can be slow when working on a network drive in particular because each file link is verified against the file system. Changing this will take effect only in new terminals.
  "terminal.integrated.enableFileLinks": true,

  // Persist terminal sessions for the workspace across window reloads.
  "terminal.integrated.enablePersistentSessions": true,

  // Object with environment variables that will be added to the VS Code process to be used by the terminal on Linux. Set to `null` to delete the environment variable.
  "terminal.integrated.env.linux": {},

  // Object with environment variables that will be added to the VS Code process to be used by the terminal on macOS. Set to `null` to delete the environment variable.
  "terminal.integrated.env.osx": {},

  // Object with environment variables that will be added to the VS Code process to be used by the terminal on Windows. Set to `null` to delete the environment variable.
  "terminal.integrated.env.windows": {},

  // Whether to display the environment changes indicator on each terminal which explains whether extensions have made, or want to make changes to the terminal's environment.
  //  - off: Disable the indicator.
  //  - on: Enable the indicator.
  //  - warnonly: Only show the warning indicator when a terminal's environment is 'stale', not the information indicator that shows a terminal has had its environment modified by an extension.
  "terminal.integrated.environmentChangesIndicator": "warnonly",

  // Whether to relaunch terminals automatically if extension want to contribute to their environment and have not been interacted with yet.
  "terminal.integrated.environmentChangesRelaunch": true,

  // Scrolling speed multiplier when pressing `Alt`.
  "terminal.integrated.fastScrollSensitivity": 5,

  // Controls the font family of the terminal, this defaults to `editor.fontFamily`'s value.
  "terminal.integrated.fontFamily": "",

  // Controls the font size in pixels of the terminal.
  "terminal.integrated.fontSize": 14,

  // The font weight to use within the terminal for non-bold text. Accepts "normal" and "bold" keywords or numbers between 1 and 1000.
  "terminal.integrated.fontWeight": "normal",

  // The font weight to use within the terminal for bold text. Accepts "normal" and "bold" keywords or numbers between 1 and 1000.
  "terminal.integrated.fontWeightBold": "bold",

  // Controls whether the terminal will leverage the GPU to do its rendering.
  //  - auto: Let VS Code detect which renderer will give the best experience.
  //  - on: Enable GPU acceleration within the terminal.
  //  - off: Disable GPU acceleration within the terminal.
  "terminal.integrated.gpuAcceleration": "auto",

  // Whether new shells should inherit their environment from VS Code, which may source a login shell to ensure $PATH and other development variables are initialized. This has no effect on Windows.
  "terminal.integrated.inheritEnv": true,

  // Controls the letter spacing of the terminal, this is an integer value which represents the amount of additional pixels to add between characters.
  "terminal.integrated.letterSpacing": 0,

  // Controls the line height of the terminal, this number is multiplied by the terminal font size to get the actual line-height in pixels.
  "terminal.integrated.lineHeight": 1,

  // Controls whether to force selection when using Option+click on macOS. This will force a regular (line) selection and disallow the use of column selection mode. This enables copying and pasting using the regular terminal selection, for example, when mouse mode is enabled in tmux.
  "terminal.integrated.macOptionClickForcesSelection": false,

  // Controls whether to treat the option key as the meta key in the terminal on macOS.
  "terminal.integrated.macOptionIsMeta": false,

  // When set the foreground color of each cell will change to try meet the contrast ratio specified. Example values:
  //
  // - 1: The default, do nothing.
  // - 4.5: WCAG AA compliance (minimum).
  // - 7: WCAG AAA compliance (enhanced).
  // - 21: White on black or black on white.
  "terminal.integrated.minimumContrastRatio": 1,

  // A multiplier to be used on the `deltaY` of mouse wheel scroll events.
  "terminal.integrated.mouseWheelScrollSensitivity": 1,

  // The Linux profiles to present when creating a new terminal via the terminal dropdown. When set, these will override the default detected profiles. They are comprised of a `path` and optional `args`.
  "terminal.integrated.profiles.linux": {},

  // The macOS profiles to present when creating a new terminal via the terminal dropdown. When set, these will override the default detected profiles. They are comprised of a `path` and optional `args`.
  "terminal.integrated.profiles.osx": {},

  // The Windows profiles to present when creating a new terminal via the terminal dropdown. Set to null to exclude them, use the `source` property to use the default detected configuration. Or, set the `path` and optional `args`.
  "terminal.integrated.profiles.windows": {},

  // Controls how terminal reacts to right click.
  //  - default: Show the context menu.
  //  - copyPaste: Copy when there is a selection, otherwise paste.
  //  - paste: Paste on right click.
  //  - selectWord: Select the word under the cursor and show the context menu.
  "terminal.integrated.rightClickBehavior": "copyPaste",

  // Controls the maximum amount of lines the terminal keeps in its buffer.
  "terminal.integrated.scrollback": 1000,

  // Dispatches most keybindings to the terminal instead of the workbench, overriding `terminal.integrated.commandsToSkipShell`, which can be used alternatively for fine tuning.
  "terminal.integrated.sendKeybindingsToShell": false,

  // Controls whether to show the alert "The terminal process terminated with exit code" when exit code is non-zero.
  "terminal.integrated.showExitAlert": true,

  // Controls the working directory a split terminal starts with.
  //  - workspaceRoot: A new split terminal will use the workspace root as the working directory. In a multi-root workspace a choice for which root folder to use is offered.
  //  - initial: A new split terminal will use the working directory that the parent terminal started with.
  //  - inherited: On macOS and Linux, a new split terminal will use the working directory of the parent terminal. On Windows, this behaves the same as initial.
  "terminal.integrated.splitCwd": "inherited",

  // Controls whether terminal tabs display as a list to the side of the terminal. When this is disabled a dropdown will display instead.
  "terminal.integrated.tabs.enabled": true,

  // Controls whether focusing the terminal of a tab happens on double or single click.
  //  - singleClick: Focus the terminal when clicking a terminal tab
  //  - doubleClick: Focus the terminal when double clicking a terminal tab
  "terminal.integrated.tabs.focusMode": "doubleClick",

  // Controls whether the terminal tabs view will hide under certain conditions.
  //  - never: Never hide the terminal tabs view
  //  - singleTerminal: Hide the terminal tabs view when there is only a single terminal opened
  //  - singleGroup: Hide the terminal tabs view when there is only a single terminal group opened
  "terminal.integrated.tabs.hideCondition": "singleTerminal",

  // Controls the location of the terminal tabs, either to the left or right of the actual terminal(s).
  //  - left: Show the terminal tabs view to the left of the terminal
  //  - right: Show the terminal tabs view to the right of the terminal
  "terminal.integrated.tabs.location": "right",

  // Shows the active terminal information in the view, this is particularly useful when the title within the tabs aren't visible.
  //  - always: Always show the active terminal
  //  - singleTerminal: Show the active terminal when it is the only terminal opened
  //  - singleTerminalOrNarrow: Show the active terminal when it is the only terminal opened or when the tabs view is in its narrow textless state
  //  - never: Never show the active terminal
  "terminal.integrated.tabs.showActiveTerminal": "singleTerminalOrNarrow",

  // Determines how the terminal's title is set, this shows up in the terminal's tab or dropdown entry.
  //  - executable: The title is set by the terminal, the name of the detected foreground process will be used.
  //  - sequence: The title is set by the process via an escape sequence, this is useful if your shell dynamically sets the title.
  "terminal.integrated.titleMode": "executable",

  // Controls what version of unicode to use when evaluating the width of characters in the terminal. If you experience emoji or other wide characters not taking up the right amount of space or backspace either deleting too much or too little then you may want to try tweaking this setting.
  //  - 6: Version 6 of unicode, this is an older version which should work better on older systems.
  //  - 11: Version 11 of unicode, this version provides better support on modern systems that use modern versions of unicode.
  "terminal.integrated.unicodeVersion": "11",

  // Controls whether or not WSL distros are shown in the terminal dropdown
  "terminal.integrated.useWslProfiles": true,

  // Whether to use ConPTY for Windows terminal process communication (requires Windows 10 build number 18309+). Winpty will be used if this is false.
  "terminal.integrated.windowsEnableConpty": true,

  // A string containing all characters to be considered word separators by the double click to select word feature.
  "terminal.integrated.wordSeparators": " ()[]{}',\"`─",

  // Tasks

  // Controls enablement of `provideTasks` for all task provider extension. If the Tasks: Run Task command is slow, disabling auto detect for task providers may help. Individual extensions may also provide settings that disable auto detection.
  "task.autoDetect": "on",

  // Configures whether to show the problem matcher prompt when running a task. Set to `true` to never prompt, or use a dictionary of task types to turn off prompting only for specific task types.
  "task.problemMatchers.neverPrompt": false,

  // Controls whether to show the task detail for tasks that have a detail in task quick picks, such as Run Task.
  "task.quickOpen.detail": true,

  // Controls the number of recent items tracked in task quick open dialog.
  "task.quickOpen.history": 30,

  // Causes the Tasks: Run Task command to use the slower "show all" behavior instead of the faster two level picker where tasks are grouped by provider.
  "task.quickOpen.showAll": false,

  // Controls whether the task quick pick is skipped when there is only one task to pick from.
  "task.quickOpen.skip": false,

  // Save all dirty editors before running a task.
  //  - always: Always saves all editors before running.
  //  - never: Never saves editors before running.
  //  - prompt: Prompts whether to save editors before running.
  "task.saveBeforeRun": "always",

  // Configures whether a warning is shown when a provider is slow
  "task.slowProviderWarning": true,

  // Problems

  // Controls whether Problems view should automatically reveal files when opening them.
  "problems.autoReveal": true,

  // Show Errors & Warnings on files and folder.
  "problems.decorations.enabled": true,

  // When enabled shows the current problem in the status bar.
  "problems.showCurrentInStatus": false,

  // Breadcrumb Navigation

  // Enable/disable navigation breadcrumbs.
  "breadcrumbs.enabled": true,

  // Controls whether and how file paths are shown in the breadcrumbs view.
  //  - on: Show the file path in the breadcrumbs view.
  //  - off: Do not show the file path in the breadcrumbs view.
  //  - last: Only show the last element of the file path in the breadcrumbs view.
  "breadcrumbs.filePath": "on",

  // Render breadcrumb items with icons.
  "breadcrumbs.icons": true,

  // When enabled breadcrumbs show `array`-symbols.
  "breadcrumbs.showArrays": true,

  // When enabled breadcrumbs show `boolean`-symbols.
  "breadcrumbs.showBooleans": true,

  // When enabled breadcrumbs show `class`-symbols.
  "breadcrumbs.showClasses": true,

  // When enabled breadcrumbs show `constant`-symbols.
  "breadcrumbs.showConstants": true,

  // When enabled breadcrumbs show `constructor`-symbols.
  "breadcrumbs.showConstructors": true,

  // When enabled breadcrumbs show `enumMember`-symbols.
  "breadcrumbs.showEnumMembers": true,

  // When enabled breadcrumbs show `enum`-symbols.
  "breadcrumbs.showEnums": true,

  // When enabled breadcrumbs show `event`-symbols.
  "breadcrumbs.showEvents": true,

  // When enabled breadcrumbs show `field`-symbols.
  "breadcrumbs.showFields": true,

  // When enabled breadcrumbs show `file`-symbols.
  "breadcrumbs.showFiles": true,

  // When enabled breadcrumbs show `function`-symbols.
  "breadcrumbs.showFunctions": true,

  // When enabled breadcrumbs show `interface`-symbols.
  "breadcrumbs.showInterfaces": true,

  // When enabled breadcrumbs show `key`-symbols.
  "breadcrumbs.showKeys": true,

  // When enabled breadcrumbs show `method`-symbols.
  "breadcrumbs.showMethods": true,

  // When enabled breadcrumbs show `module`-symbols.
  "breadcrumbs.showModules": true,

  // When enabled breadcrumbs show `namespace`-symbols.
  "breadcrumbs.showNamespaces": true,

  // When enabled breadcrumbs show `null`-symbols.
  "breadcrumbs.showNull": true,

  // When enabled breadcrumbs show `number`-symbols.
  "breadcrumbs.showNumbers": true,

  // When enabled breadcrumbs show `object`-symbols.
  "breadcrumbs.showObjects": true,

  // When enabled breadcrumbs show `operator`-symbols.
  "breadcrumbs.showOperators": true,

  // When enabled breadcrumbs show `package`-symbols.
  "breadcrumbs.showPackages": true,

  // When enabled breadcrumbs show `property`-symbols.
  "breadcrumbs.showProperties": true,

  // When enabled breadcrumbs show `string`-symbols.
  "breadcrumbs.showStrings": true,

  // When enabled breadcrumbs show `struct`-symbols.
  "breadcrumbs.showStructs": true,

  // When enabled breadcrumbs show `typeParameter`-symbols.
  "breadcrumbs.showTypeParameters": true,

  // When enabled breadcrumbs show `variable`-symbols.
  "breadcrumbs.showVariables": true,

  // Controls whether and how symbols are shown in the breadcrumbs view.
  //  - on: Show all symbols in the breadcrumbs view.
  //  - off: Do not show symbols in the breadcrumbs view.
  //  - last: Only show the current symbol in the breadcrumbs view.
  "breadcrumbs.symbolPath": "on",

  // Controls how symbols are sorted in the breadcrumbs outline view.
  //  - position: Show symbol outline in file position order.
  //  - name: Show symbol outline in alphabetical order.
  //  - type: Show symbol outline in symbol type order.
  "breadcrumbs.symbolSortOrder": "position",

  // Telemetry

  // Enable crash reports to be sent to a Microsoft online service.
  // This option requires restart to take effect.
  "telemetry.enableCrashReporter": true,

  // Enable usage data and errors to be sent to a Microsoft online service.
  "telemetry.enableTelemetry": true,

  // Outline

  // Render Outline Elements with Icons.
  "outline.icons": true,

  // Use badges for Errors & Warnings.
  "outline.problems.badges": true,

  // Use colors for Errors & Warnings.
  "outline.problems.colors": true,

  // Show Errors & Warnings on Outline Elements.
  "outline.problems.enabled": true,

  // When enabled outline shows `array`-symbols.
  "outline.showArrays": true,

  // When enabled outline shows `boolean`-symbols.
  "outline.showBooleans": true,

  // When enabled outline shows `class`-symbols.
  "outline.showClasses": true,

  // When enabled outline shows `constant`-symbols.
  "outline.showConstants": true,

  // When enabled outline shows `constructor`-symbols.
  "outline.showConstructors": true,

  // When enabled outline shows `enumMember`-symbols.
  "outline.showEnumMembers": true,

  // When enabled outline shows `enum`-symbols.
  "outline.showEnums": true,

  // When enabled outline shows `event`-symbols.
  "outline.showEvents": true,

  // When enabled outline shows `field`-symbols.
  "outline.showFields": true,

  // When enabled outline shows `file`-symbols.
  "outline.showFiles": true,

  // When enabled outline shows `function`-symbols.
  "outline.showFunctions": true,

  // When enabled outline shows `interface`-symbols.
  "outline.showInterfaces": true,

  // When enabled outline shows `key`-symbols.
  "outline.showKeys": true,

  // When enabled outline shows `method`-symbols.
  "outline.showMethods": true,

  // When enabled outline shows `module`-symbols.
  "outline.showModules": true,

  // When enabled outline shows `namespace`-symbols.
  "outline.showNamespaces": true,

  // When enabled outline shows `null`-symbols.
  "outline.showNull": true,

  // When enabled outline shows `number`-symbols.
  "outline.showNumbers": true,

  // When enabled outline shows `object`-symbols.
  "outline.showObjects": true,

  // When enabled outline shows `operator`-symbols.
  "outline.showOperators": true,

  // When enabled outline shows `package`-symbols.
  "outline.showPackages": true,

  // When enabled outline shows `property`-symbols.
  "outline.showProperties": true,

  // When enabled outline shows `string`-symbols.
  "outline.showStrings": true,

  // When enabled outline shows `struct`-symbols.
  "outline.showStructs": true,

  // When enabled outline shows `typeParameter`-symbols.
  "outline.showTypeParameters": true,

  // When enabled outline shows `variable`-symbols.
  "outline.showVariables": true,

  // Timeline

  // An array of Timeline sources that should be excluded from the Timeline view.
  "timeline.excludeSources": null,

  // The number of items to show in the Timeline view by default and when loading more items. Setting to `null` (the default) will automatically choose a page size based on the visible area of the Timeline view.
  "timeline.pageSize": null,

  // Default Configuration Overrides

  // Configure settings to be overridden for [css] language.
  "[css]": {
  "editor.suggest.insertMode": "replace"
  },

  // Configure settings to be overridden for [dockerfile] language.
  "[dockerfile]": {
  "editor.quickSuggestions": {
  "strings": true
  }
  },

  // Configure settings to be overridden for [git-commit] language.
  "[git-commit]": {
  "editor.rulers": [72],
  "workbench.editor.restoreViewState": false
  },

  // Configure settings to be overridden for [git-rebase] language.
  "[git-rebase]": {
  "workbench.editor.restoreViewState": false
  },

  // Configure settings to be overridden for [go] language.
  "[go]": {
  "editor.insertSpaces": false
  },

  // Configure settings to be overridden for [handlebars] language.
  "[handlebars]": {
  "editor.suggest.insertMode": "replace"
  },

  // Configure settings to be overridden for [html] language.
  "[html]": {
  "editor.suggest.insertMode": "replace"
  },

  // Configure settings to be overridden for [json] language.
  "[json]": {
  "editor.quickSuggestions": {
  "strings": true
  },
  "editor.suggest.insertMode": "replace"
  },

  // Configure settings to be overridden for [jsonc] language.
  "[jsonc]": {
  "editor.quickSuggestions": {
  "strings": true
  },
  "editor.suggest.insertMode": "replace"
  },

  // Configure settings to be overridden for [less] language.
  "[less]": {
  "editor.suggest.insertMode": "replace"
  },

  // Configure settings to be overridden for [makefile] language.
  "[makefile]": {
  "editor.insertSpaces": false
  },

  // Configure settings to be overridden for [markdown] language.
  "[markdown]": {
  "editor.wordWrap": "on",
  "editor.quickSuggestions": false
  },

  // Configure settings to be overridden for [scss] language.
  "[scss]": {
  "editor.suggest.insertMode": "replace"
  },

  // Configure settings to be overridden for [search-result] language.
  "[search-result]": {
  "editor.lineNumbers": "off"
  },

  // Configure settings to be overridden for [shellscript] language.
  "[shellscript]": {
  "files.eol": "\n"
  },

  // Configure settings to be overridden for [yaml] language.
  "[yaml]": {
  "editor.insertSpaces": true,
  "editor.tabSize": 2,
  "editor.autoIndent": "advanced"
  },

  // Remote

  // When enabled, new running processes are detected and ports that they listen on are automatically forwarded.
  "remote.autoForwardPorts": true,

  // Sets the source from which ports are automatically forwarded when `remote.autoForwardPorts` is true. On Windows and Mac remotes, the `process` option has no effect and `output` will be used. Requires a reload to take effect.
  //  - process: Ports will be automatically forwarded when discovered by watching for processes that are started and include a port.
  //  - output: Ports will be automatically forwarded when discovered by reading terminal and debug output. Not all processes that use ports will print to the integrated terminal or debug console, so some ports will be missed. Ports forwarded based on output will not be "un-forwarded" until reload or until the port is closed by the user in the Ports view.
  "remote.autoForwardPortsSource": "process",

  // When enabled extensions are downloaded locally and installed on remote.
  "remote.downloadExtensionsLocally": false,

  // Override the kind of an extension. `ui` extensions are installed and run on the local machine while `workspace` extensions are run on the remote. By overriding an extension's default kind using this setting, you specify if that extension should be installed and enabled locally or remotely.
  "remote.extensionKind": {
  "pub.name": ["ui"]
  },

  // Set default properties that are applied to all ports that don't get properties from the setting `remote.portsAttributes`.
  "remote.otherPortsAttributes": {},

  // Set properties that are applied when a specific port number is forwarded.
  "remote.portsAttributes": {},

  // Restores the ports you forwarded in a workspace.
  "remote.restoreForwardedPorts": true,

  // Emmet

  // An array of languages where Emmet abbreviations should not be expanded.
  "emmet.excludeLanguages": ["markdown"],

  // An array of paths, where each path can contain Emmet syntaxProfiles and/or snippet files.
  // In case of conflicts, the profiles/snippets of later paths will override those of earlier paths.
  "emmet.extensionsPath": [],

  // Enable Emmet abbreviations in languages that are not supported by default. Add a mapping here between the language and Emmet supported language.
  //  For example: `{"vue-html": "html", "javascript": "javascriptreact"}`
  "emmet.includeLanguages": {},

  // When set to `false`, the whole file is parsed to determine if current position is valid for expanding Emmet abbreviations. When set to `true`, only the content around the current position in CSS/SCSS/Less files is parsed.
  "emmet.optimizeStylesheetParsing": true,

  // Preferences used to modify behavior of some actions and resolvers of Emmet.
  "emmet.preferences": {},

  // Shows possible Emmet abbreviations as suggestions. Not applicable in stylesheets or when emmet.showExpandedAbbreviation is set to `"never"`.
  "emmet.showAbbreviationSuggestions": true,

  // Shows expanded Emmet abbreviations as suggestions.
  // The option `"inMarkupAndStylesheetFilesOnly"` applies to html, haml, jade, slim, xml, xsl, css, scss, sass, less and stylus.
  // The option `"always"` applies to all parts of the file regardless of markup/css.
  "emmet.showExpandedAbbreviation": "always",

  // If `true`, then Emmet suggestions will show up as snippets allowing you to order them as per `editor.snippetSuggestions` setting.
  "emmet.showSuggestionsAsSnippets": false,

  // Define profile for specified syntax or use your own profile with specific rules.
  "emmet.syntaxProfiles": {},

  // When enabled, Emmet abbreviations are expanded when pressing TAB.
  "emmet.triggerExpansionOnTab": false,

  // Variables to be used in Emmet snippets.
  "emmet.variables": {},

  // Git

  // Controls whether force push (with or without lease) is enabled.
  "git.allowForcePush": false,

  // Controls whether commits without running pre-commit and commit-msg hooks are allowed.
  "git.allowNoVerifyCommit": false,

  // Always show the Staged Changes resource group.
  "git.alwaysShowStagedChangesResourceGroup": false,

  // Controls the signoff flag for all commits.
  "git.alwaysSignOff": false,

  // When set to true, commits will automatically be fetched from the default remote of the current Git repository. Setting to `all` will fetch from all remotes.
  "git.autofetch": false,

  // Duration in seconds between each automatic git fetch, when `git.autofetch` is enabled.
  "git.autofetchPeriod": 180,

  // Whether auto refreshing is enabled.
  "git.autorefresh": true,

  // Configures when repositories should be automatically detected.
  //  - true: Scan for both subfolders of the current opened folder and parent folders of open files.
  //  - false: Disable automatic repository scanning.
  //  - subFolders: Scan for subfolders of the currently opened folder.
  //  - openEditors: Scan for parent folders of open files.
  "git.autoRepositoryDetection": true,

  // Stash any changes before pulling and restore them after successful pull.
  "git.autoStash": false,

  // Controls the sort order for branches.
  "git.branchSortOrder": "committerdate",

  // A regular expression to validate new branch names.
  "git.branchValidationRegex": "",

  // The character to replace whitespace in new branch names.
  "git.branchWhitespaceChar": "-",

  // Controls what type of git refs are listed when running `Checkout to...`.
  "git.checkoutType": ["local", "remote", "tags"],

  // Always confirm the creation of empty commits for the 'Git: Commit Empty' command.
  "git.confirmEmptyCommits": true,

  // Controls whether to ask for confirmation before force-pushing.
  "git.confirmForcePush": true,

  // Controls whether to ask for confirmation before commiting without verification.
  "git.confirmNoVerifyCommit": true,

  // Confirm before synchronizing git repositories.
  "git.confirmSync": true,

  // Controls the Git count badge.
  //  - all: Count all changes.
  //  - tracked: Count only tracked changes.
  //  - off: Turn off counter.
  "git.countBadge": "all",

  // Controls whether Git contributes colors and badges to the Explorer and the Open Editors view.
  "git.decorations.enabled": true,

  // The default location to clone a git repository.
  "git.defaultCloneDirectory": null,

  // Controls whether to automatically detect git submodules.
  "git.detectSubmodules": true,

  // Controls the limit of git submodules detected.
  "git.detectSubmodulesLimit": 10,

  // Enables commit signing with GPG or X.509.
  "git.enableCommitSigning": false,

  // Whether git is enabled.
  "git.enabled": true,

  // Commit all changes when there are no staged changes.
  "git.enableSmartCommit": false,

  // Controls whether the Git Sync command appears in the status bar.
  "git.enableStatusBarSync": true,

  // When enabled, fetch all branches when pulling. Otherwise, fetch just the current one.
  "git.fetchOnPull": false,

  // Follow push all tags when running the sync command.
  "git.followTagsWhenSync": false,

  // List of git repositories to ignore.
  "git.ignoredRepositories": [],

  // Ignores the legacy Git warning.
  "git.ignoreLegacyWarning": false,

  // Ignores the warning when there are too many changes in a repository.
  "git.ignoreLimitWarning": false,

  // Ignores the warning when Git is missing.
  "git.ignoreMissingGitWarning": false,

  // Ignores the warning when it looks like the branch might have been rebased when pulling.
  "git.ignoreRebaseWarning": false,

  // Ignore modifications to submodules in the file tree.
  "git.ignoreSubmodules": false,

  // Ignores the warning when Git 2.25 - 2.26 is installed on Windows.
  "git.ignoreWindowsGit27Warning": false,

  // Controls when to show commit message input validation.
  "git.inputValidation": "warn",

  // Controls the commit message length threshold for showing a warning.
  "git.inputValidationLength": 72,

  // Controls the commit message subject length threshold for showing a warning. Unset it to inherit the value of `config.inputValidationLength`.
  "git.inputValidationSubjectLength": 50,

  // Controls whether to open a repository automatically after cloning.
  //  - always: Always open in current window.
  //  - alwaysNewWindow: Always open in a new window.
  //  - whenNoFolderOpen: Only open in current window when no folder is opened.
  //  - prompt: Always prompt for action.
  "git.openAfterClone": "prompt",

  // Controls whether the diff editor should be opened when clicking a change. Otherwise the regular editor will be opened.
  "git.openDiffOnClick": true,

  // Path and filename of the git executable, e.g. `C:\Program Files\Git\bin\git.exe` (Windows). This can also be an array of string values containing multiple paths to look up.
  "git.path": null,

  // Runs a git command after a successful commit.
  //  - none: Don't run any command after a commit.
  //  - push: Run 'Git Push' after a successful commit.
  //  - sync: Run 'Git Sync' after a successful commit.
  "git.postCommitCommand": "none",

  // Controls whether Git should check for unsaved files before committing.
  //  - always: Check for any unsaved files.
  //  - staged: Check only for unsaved staged files.
  //  - never: Disable this check.
  "git.promptToSaveFilesBeforeCommit": "always",

  // Controls whether Git should check for unsaved files before stashing changes.
  //  - always: Check for any unsaved files.
  //  - staged: Check only for unsaved staged files.
  //  - never: Disable this check.
  "git.promptToSaveFilesBeforeStash": "always",

  // Prune when fetching.
  "git.pruneOnFetch": false,

  // Fetch all tags when pulling.
  "git.pullTags": true,

  // Force git to use rebase when running the sync command.
  "git.rebaseWhenSync": false,

  // Controls whether to require explicit Git user configuration or allow Git to guess if missing.
  "git.requireGitUserConfig": true,

  // List of paths to search for git repositories in.
  "git.scanRepositories": [],

  // Controls whether to show the commit input in the Git source control panel.
  "git.showCommitInput": true,

  // Controls whether to show an inline Open File action in the Git changes view.
  "git.showInlineOpenFileAction": true,

  // Controls whether git actions should show progress.
  "git.showProgress": true,

  // Controls whether to show a notification when a push is successful.
  "git.showPushSuccessNotification": false,

  // Control which changes are automatically staged by Smart Commit.
  //  - all: Automatically stage all changes.
  //  - tracked: Automatically stage tracked changes only.
  "git.smartCommitChanges": "all",

  // Suggests to enable smart commit (commit all changes when there are no staged changes).
  "git.suggestSmartCommit": true,

  // Controls whether a notification comes up when running the Sync action, which allows the user to cancel the operation.
  "git.supportCancellation": false,

  // Controls whether to enable VS Code to be the authentication handler for git processes spawned in the integrated terminal. Note: terminals need to be restarted to pick up a change in this setting.
  "git.terminalAuthentication": true,

  // Controls which date to use for items in the Timeline view.
  //  - committed: Use the committed date
  //  - authored: Use the authored date
  "git.timeline.date": "committed",

  // Controls whether to show the commit author in the Timeline view.
  "git.timeline.showAuthor": true,

  // Controls how untracked changes behave.
  //  - mixed: All changes, tracked and untracked, appear together and behave equally.
  //  - separate: Untracked changes appear separately in the Source Control view. They are also excluded from several actions.
  //  - hidden: Untracked changes are hidden and excluded from several actions.
  "git.untrackedChanges": "mixed",

  // Controls whether to use the message from the commit input box as the default stash message.
  "git.useCommitInputAsStashMessage": false,

  // Controls whether force pushing uses the safer force-with-lease variant.
  "git.useForcePushWithLease": true,

  // Controls whether to enable automatic GitHub authentication for git commands within VS Code.
  "github.gitAuthentication": true,

  // URI of your GitHub Enterprise Instance
  "github-enterprise.uri": "",

  // Grunt
  // Controls enablement of Grunt task detection. Grunt task detection can cause files in any open workspace to be executed.
  "grunt.autoDetect": "off",

  // Gulp

  // Controls enablement of Gulp task detection. Gulp task detection can cause files in any open workspace to be executed.
  "gulp.autoDetect": "off",

  // Jake
  // Controls enablement of Jake task detection. Jake task detection can cause files in any open workspace to be executed.
  "jake.autoDetect": "off",

  // Merge Conflict

  // Whether to automatically navigate to the next merge conflict after resolving a merge conflict.
  "merge-conflict.autoNavigateNextConflict.enabled": false,

  // Create a CodeLens for merge conflict blocks within editor.
  "merge-conflict.codeLens.enabled": true,

  // Create decorators for merge conflict blocks within editor.
  "merge-conflict.decorators.enabled": true,

  // Controls where the diff view should be opened when comparing changes in merge conflicts.
  //  - Current: Open the diff view in the current editor group.
  //  - Beside: Open the diff view next to the current editor group.
  //  - Below: Open the diff view below the current editor group.
  "merge-conflict.diffViewPosition": "Current",

  // JavaScript Debugger

  // Configures which processes to automatically attach and debug when `debug.node.autoAttach` is on. A Node process launched with the `--inspect` flag will always be attached to, regardless of this setting.
  //  - always: Auto attach to every Node.js process launched in the terminal.
  //  - smart: Auto attach when running scripts that aren't in a node_modules folder.
  //  - onlyWithFlag: Only auto attach when the `--inspect` is given.
  //  - disabled: Auto attach is disabled and not shown in status bar.
  "debug.javascript.autoAttachFilter": "disabled",

  #############
  ## SEE BOTTOM
  #############

  // Configures whether property getters will be expanded automatically. If this is false, the getter will appear as `get propertyName` and will only be evaluated when you click on it.
  "debug.javascript.autoExpandGetters": false,

  // When debugging a remote web app, configures whether to automatically tunnel the remote server to your local machine.
  "debug.javascript.automaticallyTunnelRemoteServer": true,

  // Whether to stop when conditional breakpoints throw an error. Note: your launch.json `type` must be prefixed with `pwa-` to use this, such as `pwa-node`.
  "debug.javascript.breakOnConditionalError": false,

  // Where a "Run" and "Debug" code lens should be shown in your npm scripts. It may be on "all", scripts, on "top" of the script section, or "never".
  "debug.javascript.codelens.npmScripts": "top",

  // Options used when debugging open links clicked from inside the JavaScript Debug Terminal. Can be set to "off" to disable this behavior, or "always" to enable debugging in all terminals.
  "debug.javascript.debugByLinkOptions": "on",

  // The default `runtimeExecutable` used for launch configurations, if unspecified. This can be used to config custom paths to Node.js or browser installations.
  "debug.javascript.defaultRuntimeExecutable": {
  "pwa-node": "node"
  },

  // Default options used when debugging a process through the `Debug: Attach to Node.js Process` command.
  "debug.javascript.pickAndAttachOptions": {},

  // Request options to use when loading resources, such as source maps, in the debugger. You may need to configure this if your sourcemaps require authentication or use a self-signed certificate, for instance. Options are used to create a request using the `got`library.
  // A common case to disable certificate verification can be done by passing `{ "https": { "rejectUnauthorized": false } }`.
  "debug.javascript.resourceRequestOptions": {},

  // Whether to suggest pretty printing JavaScript code that looks minified when you step into it.
  "debug.javascript.suggestPrettyPrinting": true,

  // Default launch options for the JavaScript debug terminal and npm scripts.
  "debug.javascript.terminalOptions": {},

  // Configures whether sourcemapped file where the original file can't be read will automatically be unmapped. If this is false (default), a prompt is shown.
  "debug.javascript.unmapMissingSources": false,

  // Use the new in-preview JavaScript debugger for Node.js and Chrome.
  "debug.javascript.usePreview": true,

  // Controls whether to show a warning when the 'useWSL' attribute is used.
  "debug.node.showUseWslIsDeprecatedWarning": true,

  // References Search View

  // Controls whether 'Peek References' or 'Find References' is invoked when selecting CodeLens references.
  //  - peek: Show references in peek editor.
  //  - view: Show references in separate view.
  "references.preferredLocation": "peek",

  // Npm

  // Controls whether npm scripts should be automatically detected.
  "npm.autoDetect": "on",

  // Enable running npm scripts contained in a folder from the Explorer context menu.
  "npm.enableRunFromFolder": false,

  // The NPM Script Explorer is now available in 'Views' menu in the Explorer in all folders.
  // Enable an explorer view for npm scripts when there is no top-level 'package.json' file.
  "npm.enableScriptExplorer": false,

  // Configure glob patterns for folders that should be excluded from automatic script detection.
  "npm.exclude": "",

  // Fetch data from https://registry.npmjs.org and https://registry.bower.io to provide auto-completion and information on hover features on npm dependencies.
  "npm.fetchOnlinePackageInfo": true,

  // The package manager used to run scripts.
  //  - auto: Auto-detect which package manager to use for running scripts based on lock files and installed package managers.
  //  - npm: Use npm as the package manager for running scripts.
  //  - yarn: Use yarn as the package manager for running scripts.
  //  - pnpm: Use pnpm as the package manager for running scripts.
  "npm.packageManager": "auto",

  // Run npm commands with the `--silent` option.
  "npm.runSilent": false,

  // The default click action used in the npm scripts explorer: `open` or `run`, the default is `open`.
  "npm.scriptExplorerAction": "open"
  }
*/

# Configures glob patterns for determining when to attach in "smart" `debug.javascript.autoAttachFilter` mode. `$KNOWN_TOOLS$` is replaced with a list of names of common test and code runners.
#  "debug.javascript.autoAttachSmartPattern": [
#    "${workspaceFolder}/**",
#    "!**/node_modules/**",
#    "**/$KNOWN_TOOLS$/**"
#],
