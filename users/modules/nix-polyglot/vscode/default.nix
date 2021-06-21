{ config, lib, pkgs, options, ... }:

with lib;
with builtins;

let
  cfg = config.nix-polyglot.vscode;
  polyglot = config.nix-polyglot;

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
  defaultUserSettings = {
    editor = {
      fontFamily =
        "'JetBrainsMono Nerd Font Mono', monospace, 'Droid Sans Fallback'";
      fontLigatures = true;
      inlayHints.fontFamily =
        "'VictorMono Nerd Font Mono', monospace, 'Droid Sans Fallback'";
    };
    update.mode = "none";
  };

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
        #userSettings = (builtins.toJSON cfg.userSettings);
        extensions = defaultExt;
      };
      ZSH.shellAliases = aliases;
    };
    home = {
      packages = [ pkgs.nerdfonts ];

      file = {
        "${configFilePath}" = mkIf (cfg.userSettings != { }) {
          source = writePrettyJSON "vscode-user-settings"
            (cfg.userSettings // defaultUserSettings);
        };
      };
    };
  }]);

}
