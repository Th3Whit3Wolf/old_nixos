{ self
, lib
, modulesPath
, pkgs
, suites
, hardware
, profiles
, config
, ...
}:
let
  inherit (builtins) toFile readFile;
  inherit (lib) fileContents mkForce;
  theme = config.home-manager.users.doc.home.theme;
in
{
  imports = [
    (lib.mkAliasOptionModule [ "doc" ] [ "home-manager" "users" "doc" ])
  ];

  users.users.doc = {
    uid = 1000;
    description = "Just the doctor";
    isNormalUser = true;
    initialHashedPassword = fileContents ../secrets/doc;
    shell = pkgs.zsh;
    extraGroups = [
      "users"
      "wheel"
      "input"
      "networkmanager"
      "libvirtd"
      "adbusers"
      "video"
    ];
  };

  doc =
    { suites
    , lib
    , ...
    }: {
      imports = suites.tardis;

      home.theme.name = "Space Dark";

      programs = {
        git = {
          userName = "Th3Whit3Wolf";
          userEmail = "the.white.wolf.is.1337@gmail.com";
          signing = {
            key = "";
            signByDefault = false;
          };
          ignores = [ "*.swp" ".direnv" "Session.vim" ];
          extraConfig = {
            core.editor = "nvim";
            commit.verbose = true;
            credentil.helper = "${pkgs.git}/git-credential-libsecret";
            pull.ff = "only";
            fetch = {
              recurseSubmodules = "on-demand";
              prune = true;
            };
            rebase = {
              autosquash = true;
              autostash = true;
            };
            recieve.fsckobjects = true;
            status.submoduleSummary = true;
            tag.gpgSign = true;
            transfer.fsckobjects = true;
            trim.bases = "master,gh-pages";
          };
          delta = {
            options = {
              theme = "OneHalfDark";
              decorations = {
                commit-decoration-style = "bold yellow box ul";
                file-style = "bold yellow ul";
                file-decoration-style = "none";
              };
            };
          };
        };

        ssh = {
          matchBlocks = {
            github = {
              host = "github.com";
              identityFile = "~/.ssh/id_GitHub";
              extraOptions = { AddKeysToAgent = "yes"; };
            };
          };
        };
      };

      xdg.configFile = {
        "river/init" = {
          text = ''
            #!/bin/sh
            mod="Mod4"
            riverctl map normal $mod Return spawn alacritty
            riverctl map normal $mod W spawn firefox
            # Mod+Q to close the focused view
            riverctl map normal $mod Q close
            # Mod+E to exit river
            riverctl map normal $mod E exit
          '';
        };
      };
    };

  boot.kernelParams = [
    (if (theme.name != null) then
      "vt.default_red=${theme.vt.red} vt.default_grn=${theme.vt.grn} vt.default_blu=${theme.vt.blu}"
    else "")
  ];

}
