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
        type = attrsOf attrs;
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
        copyWithSyntaxHighlighting = mkOption {
          type = bool;
          default = true;
          description = ''
            Controls whether syntax highlighting should be copied into the clipboard.
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
        default =
          "'JetBrainsMono Nerd Font Mono', monospace, 'Droid Sans Fallback'";
        description = ''
          Controls the font family.
        '';
      };
      fontLigatures = mkOption {
        type = bool;
        default = true;
        description = ''
          Configures font ligatures or font features. Can be either a boolean to enable/disable ligatures or a string for the value of the CSS 'font-feature-settings' property.
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
          default =
            "'VictorMono Nerd Font Mono', monospace, 'Droid Sans Fallback'";
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
          type = enum [ "showSlider" "always" ];
          default = "showSlider";
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
      quickSuggestions = {
        other = mkOption {
          type = bool;
          default = true;
        };
        comments = mkOption {
          type = bool;
          default = false;
        };
        strings = mkOption {
          type = bool;
          default = false;
        };
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
        type = attrsOf str;
        default = { };
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
        type = either bool (enum [ "focusNoScroll" ]);
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
        type = either bool (enum [ "auto" ]);
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
        type = bool;
        default = false;
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
            Maximum number of line breaks to be preserved in one chunk. Use `null` for unlimited.
          '';
        };
      };
    };
  };
}
