{ config, lib, pkgs, ... }:

with lib;
with builtins;

let
    cfg = config.nix-polyglot.vscode;
    jsonFormat = pkgs.formats.json { };
    defaultExt = with pkgs.vscode-extensions; [
    #pkief.material-icon-theme
    #ms-azuretools.vscode-docker
    #ms-kubernetes-tools.vscode-kubernetes-tools
    #ms-vscode-remote.remote-ssh
    #ms-vscode-remote.remote-ssh-edit
    redhat.vscode-yaml
    #coenraads.bracket-pair-colorizer-2
    #oderwat.indent-rainbow
    #mechatroner.rainbow-csv
    #mikestead.dotenv
    #roscop.activefileinstatusbar
    #yzhang.markdown-all-in-one
    #shd101wyy.markdown-preview-enhanced
    #adpyke.codesnap
    #pflannery.vscode-versionlens
    #dendron.dendron
    #tamasfe.even-better-toml
    #christian-kohler.path-intellisense
    #aaron-bond.better-comments
    #KnisterPeter.vscode-github
    #hardikmodha.create-tests
    #formulahendry.code-runner
    #kruemelkatze.vscode-dashboard
    #alefragnani.project-manager
    #Gruntfuggly.todo-tree
    #wwm.better-align
    #Rubymaniac.vscode-paste-and-indent
    #Tyriar.sort-lines
    #softwaredotcom.swdc-vscode
    #ryu1kn.edit-with-shell
    #spikespaz.vscode-smoothtype
    #stkb.rewrap
    #zxh404.vscode-proto3
    #skellock.just
  ];
    
in {
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
        userSettings = mkOption {
            type = jsonFormat.type;
            default = { };
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

    config = mkIf cfg.enable (mkMerge [ 
        {
            programs.vscode = {
                enable = true;
                package = (cfg.package);
                userSettings = (cfg.userSettings);
                extensions = defaultExt;
            };
        }
    ]);
}
