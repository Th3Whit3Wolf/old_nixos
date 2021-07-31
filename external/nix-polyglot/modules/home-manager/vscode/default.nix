{ config, lib, pkgs, options, ... }:

with lib;
with builtins;

let
  cfg = config.home.nix-polyglot.vscode;
  polyglot = config.home.nix-polyglot;

  # When true vscode settings will be created from all possible settings
  testing = true;

  flattenTree =
    /**
      This was stolen and modified from https://github.com/divnix/digga/blob/cb928ec8dd13f328d865d525d5dd190d46570544/src/importers.nix
      Thank you Pacman99  and blaggacao!
      Synopsis: flattenTree _tree_
      Convert nix config attrset into something more simimilar to
      vscode's settings.json and ignores key if value is equal to default.
      Output Format:
      An attrset with names in the spirit of the Reverse DNS Notation form
      that fully preserve information about grouping from nesting.
      Example input:
      ```
      {
      a = {
      b = {
      c = <value>;
      };
      };
      }
      ```
      Example output:
      ```
      {
      "a.b.c" = <value>;
      }
      ```
      **/
    tree:
    let
      op = sum: path: val:
        let
          pathStr = concatStringsSep "." path; # dot-based reverse DNS notation
          isOption = hasAttrByPath ((splitString "." pathStr) ++ [ "default" ]) options.home.nix-polyglot.vscode.userSettings;
          notDefaultVal = if testing then true else attrByPath ((splitString "." pathStr) ++ [ "default" ]) val options.home.nix-polyglot.vscode.userSettings != val;
        in
        if lib.strings.isCoercibleToString val && notDefaultVal then
        # trace "${toString val} is a path"
          (sum // {
            "${pathStr}" = val;
          })
        else if isAttrs val then
        # trace "${toJSON val} is an attrset"
        # recurse into that attribute set
          if isOption && notDefaultVal then
            (sum // {
              "${pathStr}" = val;
            })
          else if ! isOption then
            (recurse sum path val)
          else
            sum
        else
        # ignore that value
        # trace "${toString path} is something else"
          sum
      ;

      recurse = sum: path: val:
        foldl'
          (sum: key: op sum (path ++ [ key ]) val.${key})
          sum
          (attrNames val)
      ;
    in
    recurse { } [ ] tree;

  languageOverride = name:
    if hasPrefix "languageOverride." name then
      let
        lang = last (splitString "." name);
      in
      "[${lang}]"
    else
      name;


  # Returns list of all languages
  languages = lib.mapAttrsToList (name: type: "${name}")
    (lib.filterAttrs (file: type: type == "directory") (readDir (../lang)));

  /*
    * Returns all extensions for all appropriate languages
  */
  vscodeLangExt =
    if elem "all" polyglot.langs then
      flatten
        (forEach languages (lang:
          if (hasAttrByPath [ "${lang}" "vscode" "extensions" ] config.home.nix-polyglot.lang) then config.home.nix-polyglot.lang.${lang}.vscode.extensions else [ ]
        ))
    else
      flatten (forEach polyglot.langs (lang:
        if (hasAttrByPath [ "${lang}" "vscode" "extensions" ] config.home.nix-polyglot.lang) then config.home.nix-polyglot.lang.${lang}.vscode.extensions else [ ]
      ));

  allExtension = cfg.extensions ++ vscodeLangExt;

  /*
    colorThemes =
    let
    packageJson = ext: elemAt (filter (file: baseNameOf "${file}" == "package.json") (filesystem.listFilesRecursive (ext + "/share/vscode/extensions"))) 0;
    packageJsons = forEach allExtension (x: packageJson x);
    toJson = file: (fromJSON (readFile file));

    isTheme = pJson: if (hasAttr "contributes" (toJson pJson)) && (hasAttr "themes" (toJson pJson).contributes) then true else false;
    collectedThemes = filter (packages: isTheme packages) packageJsons;

    getThemes = pJson: forEach ((toJson pJson).contributes.themes) (x: if hasAttr "id" x then x.id else x.label);
    extensionThemes = flatten (forEach collectedThemes (x: getThemes x));
    in
  */

  /*
    * Returns all settings for all appropriate languages
  */
  vscodeLangSettings =
    let
      defaultSettings = (mapAttrs' (name: value: nameValuePair (languageOverride name) (value)) (flattenTree cfg.userSettings));
      additionalUserSettings = cfg.additionalUserSettings;

      langsSets =
        if elem "all" polyglot.langs then
          flatten
            (forEach languages (lang:
              if (hasAttrByPath [ "${lang}" "vscode" "settings" ] config.home.nix-polyglot.lang && config.home.nix-polyglot.lang.${lang}.vscode.settings != { }) then config.home.nix-polyglot.lang.${lang}.vscode.settings else { }
            ))
        else
          flatten (forEach polyglot.langs (lang:
            if (hasAttrByPath [ "${lang}" "vscode" "settings" ] config.home.nix-polyglot.lang && config.home.nix-polyglot.lang.${lang}.vscode.settings != { }) then config.home.nix-polyglot.lang.${lang}.vscode.settings else { }
          ));

      recursiveUpdateAttrsFromList = orig: listOfAttrs:
        if (listOfAttrs == [ ]) then
          orig
        else
          recursiveUpdateAttrsFromList (recursiveUpdate orig (head listOfAttrs)) (drop 1 listOfAttrs);
    in
    recursiveUpdateAttrsFromList (defaultSettings // additionalUserSettings) langsSets;

  colorThemes =
    let
      packageJson = ext: elemAt (filter (file: baseNameOf "${file}" == "package.json") (filesystem.listFilesRecursive (ext + "/share/vscode/extensions"))) 0;
      packageJsons = forEach allExtension (x: packageJson x);
      toJson = file: (fromJSON (readFile file));

      isTheme = pJson: if (hasAttr "contributes" (toJson pJson)) && (hasAttr "themes" (toJson pJson).contributes) then true else false;
      collectedThemes = filter (packages: isTheme packages) packageJsons;

      getThemes = pJson: forEach ((toJson pJson).contributes.themes) (x: if hasAttr "id" x then x.id else x.label);
      extensionThemes = flatten (forEach collectedThemes (x: getThemes x));
    in
    [
      # Light Themes
      "Light+ (default light)"
      "Light (Visual Studio)"
      "Quiet Light"
      "Solarized (light)"

      # Dark Themes
      "Abyss"
      "Dark+ (default dark)"
      "Dark (Visual Studio)"
      "Kimbie Dark"
      "Monokai"
      "Red"
      "Solarized Dark"
      "Tomorrow Night Blue"

      # High Contrast Themes
      "Dark High Contrast"
    ] ++ extensionThemes;

  iconThemes =
    let
      packageJson = ext: elemAt (filter (file: baseNameOf "${file}" == "package.json") (filesystem.listFilesRecursive (ext + "/share/vscode/extensions"))) 0;
      packageJsons = forEach allExtension (x: packageJson x);
      toJson = file: (fromJSON (readFile file));

      isTheme = pJson: if (hasAttr "contributes" (toJson pJson)) && (hasAttr "iconThemes" (toJson pJson).contributes) then true else false;
      collectedThemes = filter (packages: isTheme packages) packageJsons;

      getThemes = pJson: forEach ((toJson pJson).contributes.iconThemes) (x: if hasAttr "id" x then x.id else x.label);
      extensionIconThemes = flatten (forEach collectedThemes (x: getThemes x));
    in
    [
      null
      "vs-minimal"
      "vs-seti"
    ] ++ extensionIconThemes;

  show = v:
    if isString v then ''"${v}"''
    else if isInt v then toString v
    else if isBool v then boolToString v
    else if isNull v then "null"
    else ''<${typeOf v}>'';

  showValidThemes = themeType: "${concatMapStringsSep "\n" show themeType}";
  warnColorTheme = ''
    ${cfg.userSettings.workbench.colorTheme} is not a valid value!
    Valid nix-polyglot.vscode.userSettings.workbench.colorTheme values are one of the following ${toString (length colorThemes)} options:

    ${showValidThemes colorThemes}
  '';

  warnIconTheme = ''
    ${cfg.userSettings.workbench.iconTheme} is not a valid value!
    Valid nix-polyglot.vscode.userSettings.workbench.iconTheme values are one of the following ${toString (length iconThemes)} options:

    ${showValidThemes iconThemes}
  '';

  vscodePname = cfg.package.pname;
  configDir = {
    "vscode" = "Code";
    "vscode-insiders" = "Code - Insiders";
    "vscodium" = "VSCodium";
  }.${vscodePname};

  extensionDir = {
    "vscode" = ".vscode";
    "vscode-insiders" = ".vscode-insiders";
    "vscodium" = ".vscode-oss";
  }.${vscodePname};

  userDir =
    if pkgs.stdenv.hostPlatform.isDarwin then
      "Library/Application Support/${configDir}/User"
    else
      "${config.xdg.configHome}/${configDir}/User";

  jsonFormat = pkgs.formats.json { };
  writePrettyJSON = jsonFormat.generate;

  configFilePath = "${userDir}/settings.json";
  keybindingsFilePath = "${userDir}/keybindings.json";
  aliases = if (vscodePname == "vscodium") then { code = "codium"; } else { };

  defaultExt = with pkgs.vscode-extensions; [
    pkief.material-icon-theme
    #ms-azuretools.vscode-docker
    #ms-kubernetes-tools.vscode-kubernetes-tools
    ms-vscode-remote.remote-ssh
    ms-vscode-remote.remote-ssh-edit
    redhat.vscode-yaml
    a5huynh.vscode-ron
    coenraads.bracket-pair-colorizer-2
    oderwat.indent-rainbow
    mechatroner.rainbow-csv
    mikestead.dotenv
    roscop.activefileinstatusbar
    yzhang.markdown-all-in-one
    shd101wyy.markdown-preview-enhanced
    adpyke.codesnap
    pflannery.vscode-versionlens
    dendron.dendron
    tamasfe.even-better-toml
    christian-kohler.path-intellisense
    aaron-bond.better-comments
    KnisterPeter.vscode-github
    hardikmodha.create-tests
    formulahendry.code-runner
    kruemelkatze.vscode-dashboard
    alefragnani.project-manager
    gruntfuggly.todo-tree
    wwm.better-align
    rubymaniac.vscode-paste-and-indent
    tyriar.sort-lines
    streetsidesoftware.code-spell-checker
    # TODO: Test softwaredotcom.swdc-vscode on vscode
    # It may rely on proprietary code
    ryu1kn.edit-with-shell
    spikespaz.vscode-smoothtype
    stkb.rewrap
    zxh404.vscode-proto3
    skellock.just
    jock.svg
    cssho.vscode-svgviewer
    humao.rest-client
    cometeer.spacemacs
  ];
in
{
  imports = [ ./settings.nix ];
  options.home.nix-polyglot.vscode = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to enable vscode for nix-polyglot.";
    };
    package = mkOption {
      type = types.package;
      default = pkgs.vscode;
      example = literalExample "pkgs.vscodium";
      description = ''
        Version of Visual Studio Code to install.
      '';
    };
    extensions = mkOption {
      type = types.listOf types.package;
      default = defaultExt;
      example = literalExample "[ pkgs.vscode-extensions.bbenoist.Nix ]";
      description = ''
        The extensions Visual Studio Code should be started with.
        These will override but not delete manually installed ones.
      '';
    };
    additionalUserSettings = mkOption {
      type = jsonFormat.type;
      default = {
        "dashboard.projectData" = null;
      };
      example = literalExample ''
        {
          "update.channel" = "none";
          "[nix]"."editor.tabSize" = 2;
        }
      '';
      description = ''
        Configuration written to Visual Studio Code's
        <filename>settings.json</filename>.
      '';
    };
  };

  config = mkIf cfg.enable (mkMerge [{
    warnings = optional (((elem cfg.userSettings.workbench.colorTheme colorThemes) == false) || ((elem cfg.userSettings.workbench.iconTheme iconThemes) == false)) ''

      ${optionalString ((elem cfg.userSettings.workbench.colorTheme colorThemes) == false) warnColorTheme}
      ${optionalString ((elem cfg.userSettings.workbench.iconTheme iconThemes) == false) warnIconTheme}
    '';

    programs = {
      vscode = {
        enable = true;
        package = (cfg.package);
        extensions = allExtension;
      };
      zsh.shellAliases = aliases;
    };

    home = {
      packages = [ pkgs.nerdfonts ];
      nix-polyglot.vscode.userSettings = {
        editor = {
          fontFamily =
            "'JetBrainsMono Nerd Font Mono', monospace, 'Droid Sans Fallback'";
          fontLigatures = true;
          inlayHints.fontFamily =
            "'VictorMono Nerd Font Mono', monospace, 'Droid Sans Fallback'";
        };
        window.menuBarVisibility = "toggle";
        workbench = {
          colorTheme = "Spacemacs - dark";
          iconTheme = "material-icon-theme";
        };
        update = {
          mode = "none";
          showReleaseNotes = true;
        };
      };

      file = {
        "${configFilePath}" = {
          # Force json validation
          # if mkUserSettings contains invalid json this will throw
          source = writePrettyJSON "vscode-user-settings" (vscodeLangSettings);
        };
      };
    };
  }]);
}

