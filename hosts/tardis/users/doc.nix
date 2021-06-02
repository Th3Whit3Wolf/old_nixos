{ self
, lib
, modulesPath
, pkgs
, suites
, hardware
, profiles
, ...
}:
let
  inherit (builtins) toFile readFile;
  inherit (lib) fileContents mkForce;
in
{
  imports = [
    (lib.mkAliasOptionModule [ "doc" ] [ "home-manager" "users" "doc" ])
    ./git_aliases.nix
  ];

  #age = {
  #  secrets = {
  #    doc = {
  #      file = ../secrets/doc.age;
  #      path = "/run/secrets/doc";
  #    };
  #github.file = ../secrets/github.age;
  #github.owner = "doc";
  #  };
  #};

  users.users.doc = {
    uid = 1000;
    description = "Just the doctor";
    isNormalUser = true;
    initialHashedPassword = fileContents ../secrets/doc;
    extraGroups = [ "users" "wheel" "input" "networkmanager" "libvirtd" "adbusers" ];
  };

  doc = { lib, ... }: {
    home = {
      sessionVariables = {
        ACKRC = "$XDG_CONFIG_HOME/ack/ackrc";
        DCONF_PROFILE = "$XDG_CONFIG_HOME/dconf/user";
        ELINKS_CONFDIR = "$XDG_CONFIG_HOME/elinks";
        MANPAGER = "sh -c 'col -bx | bat --paging=always -l man -p'";
        PAGER = "less";
        ELECTRUMDIR = "$XDG_DATA_HOME/electrum";
        BAT_PAGER = "less -RFXi";
        LESSKEY = "$XDG_CONFIG_HOME/less/lesskey";
        LESSHISTFILE = "$XDG_CACHE_HOME/less/history";
        MOST_INITFILE = "$XDG_CONFIG_HOME/mostrc";
        GRIPHOME = "$XDG_CONFIG_HOME/grip";
        MPLAYER_HOME = "$XDG_CONFIG_HOME/mplayer";
        TERMINFO = "$XDG_DATA_HOME/terminfo";
        TERMINFO_DIRS = "$XDG_DATA_HOME/terminfo:/usr/share/terminfo";
        NOTMUCH_CONFIG = "$XDG_CONFIG_HOME/notmuch/config";
        PARALLEL_HOME = "$XDG_CONFIG_HOME/parallel";
        ICEAUTHORITY = "$XDG_CACHE_HOME/ICEauthority";
        IMAPFILTER_HOME = "$XDG_CONFIG_HOME/imapfilter";
        INPUTRC = "$XDG_CONFIG_HOME/readline/inputrc";
        SCREENRC = "$XDG_CONFIG_HOME/screen/screenrc";
        WEECHAT_HOME = "$XDG_CONFIG_HOME/weechat";
      };
      persistence."/persist/home/doc" = {
        directories = [
          ".config/pipewire/media-session.d"
          ".gnupg"
          ".cache/starship"
          ".cache/gstreamer-1.0"
          ".cache/lollypop"
          ".config/VSCodium/"
          ".local/share/cargo"
          ".local/share/direnv"
          ".local/share/gnupg"
          ".local/share/icons"
          ".local/share/keyrings"
          ".local/share/lollypop"
          ".local/share/nu"
          ".local/share/nvim"
          ".local/share/rustup"
          ".local/share/themes"
          ".local/share/Trash"
          ".local/share/zoxide"
          ".local/share/zsh"
          ".mozilla/firefox"
          ".ssh"
          ".vscode-oss"
          "Code"
          "Desk"
          "Docs"
          "Downs"
          "Pics"
          "Tunes"
          "Vids"
          "Gits"
        ];
        allowOther = true;
      };
    };

    programs = {
      git = {
        enable = true;
        userName = "Th3Whit3Wolf";
        userEmail = "the.white.wolf.is.1337@gmail.com";
        lfs.enable = true;
        signing = {
          key = "";
          signByDefault = false;
        };
        ignores = [ "*.swp" ".direnv" "Session.vim" ];
        extraConfig = {
          core = {
            quotepath = "off";
            editor = "nvim";
            excludesfile = "~/.config/git/ignore";
            whitespace = "trailing-space,space-before-tab";
          };
          color = {
            ui = "auto";
            diff = "auto";
            status = "auto";
          };
          commit.verbose = true;
          credentil.helper = "${pkgs.git}/git-credential-libsecret";
          pull.ff = "only";
          fetch = {
            recurseSubmodules = "on-demand";
            prune = true;
          };
          init.defaultBranch = "main";
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
          enable = true;
          options = {
            line-numbers = true;
            side-by-side = true;
            features = "decorations";
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
        enable = true;
        hashKnownHosts = true;
        matchBlocks = {
          github = {
            host = "github.com";
            identityFile = "~/.ssh/id_GitHub";
            extraOptions = { AddKeysToAgent = "yes"; };
          };
        };
      };

      zsh = {
        enable = true;
      };
    };
  };
}
