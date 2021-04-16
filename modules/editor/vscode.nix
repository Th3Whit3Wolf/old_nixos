{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.editor.vscode;
  lang = config.modules.dev.lang;
  vcs  = config.modules.dev.vcs;
  theme = config.modules.theme.editor.vscode;

  useTheme      = (config.modules.theme.active != null);
  useGit        = vcs.git.enable;
  useCC         = lang.cc.enable;
  useClojure    = lang.clojure.enable;
  useCommonLisp = lang.cc.enable;
  useGo         = lang.go.enable;
  useLua        = lang.lua.enable;
  useNix        = lang.nix.enable;
  useNode       = lang.node.enable;
  usePython     = lang.python.enable;
  useRuby       = lang.ruby.enable;
  useRust       = lang.rust.enable;
  useScala      = lang.scala.enable;
  useShell      = lang.shell.enable;

  themeExt      = if (useTheme && theme.extension != null)   then theme.extension else   [ ];
  gitExt        = if useGit        then vcs.git.vscodeExt else [ ];
  ccExt         = if useCC         then lang.cc.vscodeExt else [ ];
  clojureExt    = if useClojure    then lang.clojure.vscodeExt else [ ];
  commonLispExt = if useCommonLisp then lang.common-lisp.vscodeExt else [ ];
  goExt         = if useGo         then lang.go.vscode.ext else [ ];
  luaExt        = if useLua        then lang.lua.vscodeExt else [ ];
  nixExt        = if useNix        then lang.nix.vscodeExt else [ ];
  nodeExt       = if useNode       then lang.node.vscodeExt else [ ];
  pythonExt     = if usePython     then lang.python.vscode.ext else [ ];
  rubyExt       = if useRuby       then lang.ruby.vscode.ext else [ ];
  rustExt       = if useRust       then lang.rust.vscode.ext else [ ];
  scalaExt      = if useScala      then lang.scala.vscodeExt else [ ];
  shellExt      = if useShell      then lang.shell.vscode.ext else [ ];

  goSettings     = if useGo     then lang.go.vscode.settings else [ ];
  pythonSettings = if usePython then lang.python.vscode.settings else [ ];
  rubySettings   = if useRuby   then lang.ruby.vscode.settings else { };
  rustSettings   = if useRust   then lang.rust.vscode.settings else [ ];
  shellSettings  = if useShell  then lang.shell.vscode.settings else [ ];

  colorScheme = if useTheme then theme.colorTheme else "Visual Studio Dark";
  fontFamily  = if useTheme then theme.fontFamily else "'JetBrainsMono Nerd Font Mono'";

  defaultExt = with pkgs.vscode-extensions; [
    pkief.material-icon-theme
    #ms-azuretools.vscode-docker
    #ms-kubernetes-tools.vscode-kubernetes-tools
    ms-vscode-remote.remote-ssh
    ms-vscode-remote.remote-ssh-edit
    redhat.vscode-yaml
    coenraads.bracket-pair-colorizer-2
    oderwat.indent-rainbow
    mechatroner.rainbow-csv
    mikestead.dotenv
    roscop.activefileinstatusbar
    yzhang.markdown-all-in-one
    shd101wyy.markdown-preview-enhanced
    #adpyke.codesnap
    pflannery.vscode-versionlens
    dendron.dendron
    tamasfe.even-better-toml
    christian-kohler.path-intellisense
    aaron-bond.better-comments
    KnisterPeter.vscode-github
    #hardikmodha.create-tests
    #formulahendry.code-runner
    kruemelkatze.vscode-dashboard
    alefragnani.project-manager
    Gruntfuggly.todo-tree
    wwm.better-align
    Rubymaniac.vscode-paste-and-indent
    Tyriar.sort-lines
    #softwaredotcom.swdc-vscode
    ryu1kn.edit-with-shell
    spikespaz.vscode-smoothtype
    stkb.rewrap
    zxh404.vscode-proto3
    skellock.just
  ];
in {
  options.modules.editor.vscode = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      unstable.vscodium
      nodejs-12_x
      nodePackages.vscode-json-languageserver-bin
      nodePackages.vscode-html-languageserver-bin
      nodePackages.vscode-css-languageserver-bin
    ];

    home-manager.users.${config.user.name}.programs.vscode = {
      enable = true;
      package = pkgs.vscodium;
      extensions = defaultExt ++ themeExt ++ gitExt ++ ccExt ++ clojureExt ++ commonLispExt
        ++ goExt ++ luaExt ++ nixExt ++ nodeExt ++ pythonExt ++ rubyExt ++ rustExt
        ++ scalaExt ++ shellExt;
      userSettings = {
        "dashboard.projectData" = null;
        "editor" = {
          "fontFamily" = fontFamily;
          "fontLigatures" = true;
          "fontSize" = 14;
          "formatOnPaste" = true;
          "formatOnSave" = true;
          "minimap.scale" = 2;
          "scrollbar" = {
            "horizontal" = "hidden";
            "vertical" = "hidden";
          };
        };
        "extensions.webWorker" = true;
        "files" = {
          "autoGuessEncoding" = true;
          "autoSave" = "afterDelay";
          "autoSaveDelay" = 30000;
          "insertFinalNewline" = true;
          "trimFinalNewlines" = true;
          "trimTrailingWhitespace" = true;
        };
        "liveServer.settings.fullReload" = true;
        "search" = {
          "showLineNumbers" = true;
          "smartCase" = true;
        };
        "smoothtype.autoReload" = true;
        "todo-tree.tree.showScanModeButton" = false;
        "terminal.integrated" = {
          "copyOnSelection" = true;
          "cursorBlinking" = true;
          "enableBell" = true;
          "shell.linux" = "${pkgs.zsh}";
        };
        "window" = {
          "autoDetectColorScheme" = true;
          "menuBarVisibility" = "toggle";
        };
        "workbench" = {
          "colorTheme" = colorScheme;
          "editor.closeOnFileDelete" = true;
          "iconTheme" = "material-icon-theme";
          "list.smoothScrolling" = true;
          "preferredDarkColorTheme" = "Spacemacs - dark";
          "preferredLightColorTheme" = "Spacemacs - light";
          "settings.editor" = "json";
          "startupEditor" = "none";
          "tree.indent" = 4;
        };
      } // optionalAttrs useGo     goSettings 
        // optionalAttrs usePython pythonSettings 
	// optionalAttrs useRuby   rubySettings 
	// optionalAttrs useRust   rustSettings 
	// optionalAttrs useShell  shellSettings;
      keybindings = [
        {
          key = "ctrl+n";
          command = "explorer.newFile";
          when = "";
        }
        {
          key = "ctrl+shift+n";
          command = "explorer.newFolder";
          when = "";
        }
        {
          key = "ctrl+p";
          command = "-workbench.action.quickOpen";
        }
      ];
    };

    env.VSCODE_PORTABL = "$XDG_DATA_HOME/vscode";
    environment.shellAliases = { code = "codium"; };
  };
}
