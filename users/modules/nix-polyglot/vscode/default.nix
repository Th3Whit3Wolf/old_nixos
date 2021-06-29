{ config, lib, pkgs, options, ... }:

with lib;
with builtins;

let
  cfg = config.nix-polyglot.vscode;

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
        "a.b.c" = <path>;
      }
      ```
    **/
    tree:
      let
        op = sum: path: val:
          let
            pathStr = builtins.concatStringsSep "." path; # dot-based reverse DNS notation
            isOption = hasAttrByPath ((splitString "." pathStr) ++ [ "default" ]) options.nix-polyglot.vscode.userSettings;
            notDefaultVal = attrByPath ((splitString "." pathStr) ++ [ "default" ]) val options.nix-polyglot.vscode.userSettings != val;
          in
          if lib.strings.isCoercibleToString val && notDefaultVal then
          # builtins.trace "${toString val} is a path"
            (sum // {
              "${pathStr}" = val;
            })
          else if builtins.isAttrs val then
          # builtins.trace "${builtins.toJSON val} is an attrset"
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
          # builtins.trace "${toString path} is something else"
            sum
        ;

        recurse = sum: path: val:
          builtins.foldl'
            (sum: key: op sum (path ++ [ key ]) val.${key})
            sum
            (builtins.attrNames val)
        ;
      in
      recurse { } [ ] tree;

  mkUserSettings = ''
  {
    ${concatStringsSep ",\n    " (mapAttrsToList (name: value: "\"${name}\": ${toJSON value}") (flattenTree cfg.userSettings))}
  }
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

  userDir = if pkgs.stdenv.hostPlatform.isDarwin then
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
    # TODO: Test softwaredotcom.swdc-vscode on vscode
    # It may rely on proprietary code
    ryu1kn.edit-with-shell
    spikespaz.vscode-smoothtype
    stkb.rewrap
    zxh404.vscode-proto3
    skellock.just
  ];

in {
  imports = [ ./settings.nix ];
  options.nix-polyglot.vscode = {
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
  };

  config = mkIf cfg.enable (mkMerge [{
    programs = {
      vscode = {
        enable = true;
        package = (cfg.package);
        extensions = defaultExt;
      };
      ZSH.shellAliases = aliases;
    };

    nix-polyglot.vscode.userSettings = {
      editor = {
        fontFamily =
          "'JetBrainsMono Nerd Font Mono', monospace, 'Droid Sans Fallback'";
        fontLigatures = true;
        inlayHints.fontFamily =
          "'VictorMono Nerd Font Mono', monospace, 'Droid Sans Fallback'";
      };
      update = {
        enableWindowsBackgroundUpdates = false;
        mode = "none";
        showReleaseNotes = false;
      };
    };
    home = {
      packages = [ pkgs.nerdfonts ];

      file = {
        "${configFilePath}" = {
          # Force json validation
          # if mkUserSettings contains invalid json this will throw
          source = writePrettyJSON "vscode-user-settings" (fromJSON mkUserSettings);
        };
      };
    };
  }]);

}
