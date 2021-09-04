{ self, lib, modulesPath, pkgs, suites, hardware, profiles, config, nix-polyglot, ... }:
let
  inherit (builtins) toFile readFile;
  inherit (lib) fileContents mkForce;

  user = "doc";
  theme = config.home-manager.users.${user}.home.theme;
  themePackages = config.home-manager.users.${user}.home.theme.requiredPackages;
  homey = config.home-manager.users.${user}.home.homeDirectory;
  passwd = fileContents (../secrets + "/${user}");
  express = loc: ../../../secrets/vpn/expressvpn + "/${loc}";
in
{
  imports = [
    (lib.mkAliasOptionModule [ "${user}" ] [ "home-manager" "users" "${user}" ])
  ];

  users.users.${user} = {
    uid = 1000;
    description = "Just the doctor";
    isNormalUser = true;
    initialHashedPassword = passwd;
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
    packages = with pkgs;
      [
        # Git tools
        (git.override { withLibsecret = true; })
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
        river

        # Required
        firefox-wayland
        brightnessctl
        #eww
        vscodium
        QtGreet
        transmission
        transmission-gtk

      ] ++ themePackages;
  };

  vpn.expressvpn = {
    enable = true;
    auth_user_pass = express "auth.txt";
    ca = express "ca2.crt";
    client_cert = express "client.crt";
    client_key = express "client.key";
    tls_auth = express "ta.key";
  };

  services = {
    pcscd = {
      enable = true;
      plugins = with pkgs; [
        pcsclite
        opensc # Encryption
        openssl
        pcsctools
        libusb
        libusb1
        ccid
        pcsc-cyberjack
        encfs
        cryptsetup # Encrypted USB sticks etc
        pinentry # GPG password entry from the terminal
        gnupg # Encryption key management
        gnupg1orig
        pcmciaUtils # PCMCIA Tools
        acsccid # SmartCard Apps
        glibc # Para o WebSigner Certsign
        chrome-token-signing # Chrome and Firefox extension for signing with your eID on the web
      ];
    };
  };

  ${user} = { suites, lib, ... }: {
    imports = suites.tardis;

    home = {
      stateVersion = "21.05";
      theme.name = "Space Dark";
    };

    systemd.user = {
      sessionVariables = {
        ZDOTDIR = "${config.home-manager.users.${user}.home.homeDirectory}/zsh";
      };
      # This is effectively what psd does
      services.firefox-persist = {
        Unit = {
          Description = "Firefox persistent storage sync";
        };

        Service = {
          CPUSchedulingPolicy = "idle";
          IOSchedulingClass = "idle";
          Environment = "PATH=${pkgs.coreutils}";
          # copy all files except those that are symlinks
          ExecStart = toString (pkgs.writeShellScript "firefox-backup" ''
            ${pkgs.rsync}/bin/rsync -avh --exclude={'user.js','chrome','extensions'} /home/doc/.mozilla/firefox/doc /persist/home/doc/.mozilla/firefox/
          '');
        };
      };

      timers.firefox-persist = {
        Unit = {
          Description = "Firefox persistent storage periodic sync";
        };

        Timer = {
          Unit = "firefox-persist.service";
          # Run every 15 minutes
          OnCalendar = "*:0/15";
          Persistent = true;
        };

        Install = { WantedBy = [ "timers.target" ]; };
      };
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
          credential.helper = "${pkgs.git.override { withLibsecret = true; }}/bin/git-credential-libsecret";
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
      ZSH = {
        pathVar = [ "$XDG_BIN_HOME" ];
      };
    };
    services = {
      gpg-agent.pinentryFlavor = "gnome3";
    };
    xdg = {
      enable = true;
      cacheHome = "${homey}/.cache";
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
    (if (theme.vt.red != null && theme.vt.grn != null && theme.vt.blu
      != null) then
      "vt.default_red=${theme.vt.red} vt.default_grn=${theme.vt.grn} vt.default_blu=${theme.vt.blu}"
    else
      "")
  ];
}
