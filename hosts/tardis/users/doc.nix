{ lib, modulesPath, pkgs, suites, hardware, profiles, ... }:
let
  inherit (builtins) toFile readFile;
  inherit (lib) fileContents mkForce;
in
{
  imports = [

    (lib.mkAliasOptionModule [ "doc" ] [ "home-manager" "users" "doc" ])
  ];

  age.secrets = {
    doc.file = "${self}/secrets/doc.age";
    #github.file = ../secrets/github.age;
    #github.owner = "doc";
  };

  doc = { lib, ... }: {
    programs.git = {
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
          editor = "neovim";
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
      aliases = ./git_aliases.nix;
    };

    programs.ssh = {
      enable = true;
      hashKnownHosts = true;

      #   matchBlocks = {
      #    github = {
      #      host = "github.com";
      #      #identityFile = "/run/secrets/github";
      #      extraOptions = { AddKeysToAgent = "yes"; };
      #    };
      #  };
    };
  };

  users.users.doc = {
    uid = 1000;
    description = "Just the doctor";
    isNormalUser = true;
    initialHashedPassword = "/run/secrets/doc";
    extraGroups = [ "wheel" "input" "networkmanager" "libvirtd" "adbusers" ];
  };
}
