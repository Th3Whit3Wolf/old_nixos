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
  user = "doc";
  theme = config.home-manager.users.${user}.home.theme;
  themePackages = config.home-manager.users.${user}.home.theme.requiredPackages;
  homey = config.home-manager.users.${user}.home.homeDirectory;
in
{
  imports = [
    (lib.mkAliasOptionModule [ "${user}" ] [ "home-manager" "users" "${user}" ])
  ];

  users.users.${user} = {
    uid = 1000;
    description = "Just the doctor";
    isNormalUser = true;
    initialHashedPassword = fileContents (../secrets + "/${user}");
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
    packages = with pkgs; [
      # Git tools
      git
      git-crypt
      git-hub
      git-lfs
      git-subrepo
      delta
      gitoxide
      lazygit
      gitui

      gnome3.adwaita-icon-theme # Icons for gnome packages that sometimes use them but don't depend on them
      gnome3.nautilus
      gnome3.nautilus-python
      gnome3.sushi
      mesa
      sway
      river
      firefox-wayland
      brightnessctl
    ] ++ themePackages;
  };

  ${user} =
    { suites
    , lib
    , ...
    }: {
      imports = suites.tardis;

      home.theme.name = "Space Dark";

      nix-polyglot = {
        langs = [ "rust"];
        enableZshIntegration = true;
        neovim.enable = true;
        vscode = {
          enable = true;
          package = pkgs.vscodium;
        };
      };

      systemd.user.sessionVariables = {
        ZDOTDIR = "${config.home-manager.users.${user}.home.homeDirectory}/zsh";
      };

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

      xdg = {
        configFile = {
          "river/init" = {
            text = ''
              #!/bin/sh
              mod="Mod1"
              riverctl map normal $mod Return spawn alacritty
              riverctl map normal $mod W spawn firefox
              # Mod+Q to close the focused view
              riverctl map normal $mod Q close
              # Mod+E to exit river
              riverctl map normal $mod E exit
            '';
          };
        };
        userDirs = {
          enable = true;
          desktop = "${homey}/Desk";
          documents = "${homey}/Docs";
          download = "${homey}/Downs";
          music = "${homey}/Tunes";
          pictures = "${homey}/Pics";
          videos = "${homey}/Vids";
          extraConfig = {
            XDG_CODE_HOME = "${homey}/Code";
            XDG_GIT_HOME = "${homey}/Gits";
            XDG_BIN_HOME = "${homey}/.local/bin";
          };
        };
      };
    };

  boot.kernelParams = [
    (if (theme.vt.red != null && theme.vt.grn != null && theme.vt.blu != null) then
      "vt.default_red=${theme.vt.red} vt.default_grn=${theme.vt.grn} vt.default_blu=${theme.vt.blu}"
    else "")
  ];

  env.PATH = [ "$XDG_BIN_HOME" "$PATH" ];
}
