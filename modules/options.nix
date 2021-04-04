{ inputs, config, options, lib, pkgs, home-manager, ... }:

with lib;
with lib.my; 
let
    passPath = ../hosts + "/${config.networking.hostName}/secrets/${config.user.name}";
in{
  options = with types; {
    user = mkOpt attrs { };

    dotfiles = let t = either str path;
    in {
      dir = mkOpt t
        (findFirst pathExists (toString ../.) [
          "${config.user.home}/.config/dotfiles"
          "/persist/etc/dotfiles"
          "/etc/dotfiles"
        ]);
      binDir = mkOpt t "${config.dotfiles.dir}/bin";
      configDir = mkOpt t "${config.dotfiles.dir}/static";
      modulesDir = mkOpt t "${config.dotfiles.dir}/modules";
      themesDir = mkOpt t "${config.dotfiles.modulesDir}/themes";
    };

    home = {
      file = mkOpt' attrs { } "Files to place directly in $HOME";
      configFile = mkOpt' attrs { } "Files to place in $XDG_CONFIG_HOME";
      dataFile = mkOpt' attrs { } "Files to place in $XDG_DATA_HOME";
    };

    env = mkOption {
      type = attrsOf (oneOf [ str path (listOf (either str path)) ]);
      apply = mapAttrs (n: v:
        if isList v then
          concatMapStringsSep ":" (x: toString x) v
        else
          (toString v));
      default = { };
      description = "TODO";
    };
  };

  config = {
    user = let
      user = builtins.getEnv "USER";
      name = if elem user [ "" "root" ] then "doc" else user;
    in {
      inherit name;
      description = "The primary user account";
      extraGroups = [ "wheel" ];
      isNormalUser = true;
      home = "/home/${name}";
      group = "users";
      uid = 1000;
      initialHashedPassword = if (pathExists passPath) then strings.fileContents passPath else warn "${passPath} does not exist" "nixos"; 
    };
    systemd.services."home-manager-${config.user.name}" = {
      before = [ "display-manager.service" ];
      wantedBy = [ "multi-user.target" ];
    };
    programs.fuse.userAllowOther = true;

    # Install user packages to /etc/profiles instead. Necessary for
    # nixos-rebuild build-vm to work.
    home-manager = {
      useUserPackages = true;

      # I only need a subset of home-manager's capabilities. That is, access to
      # its home.file, home.xdg.configFile and home.xdg.dataFile so I can deploy
      # files easily to my $HOME, but 'home-manager.users.hlissner.home.file.*'
      # is much too long and harder to maintain, so I've made aliases in:
      #
      #   home.file        ->  home-manager.users.hlissner.home.file
      #   home.configFile  ->  home-manager.users.hlissner.home.xdg.configFile
      #   home.dataFile    ->  home-manager.users.hlissner.home.xdg.dataFile
      users.${config.user.name} = { pkgs, ... }: {
        imports = [ "${inputs.impermanence}/home-manager.nix" ];
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
          file = mkAliasDefinitions options.home.file;
          persistence."/persist/home/${config.user.name}" = {
            directories = [
              ".config/pipewire/media-session.d"
              ".gnupg"
              ".cache/starship"
              ".cache/lollypop"
              ".config/gtk-3.0"
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
            files = [ ".config/zsh/.zcompdump" ];
            allowOther = true;
          };
          # Necessary for home-manager to work with flakes, otherwise it will
          # look for a nixpkgs channel.
          stateVersion = config.system.stateVersion;
        };
        xdg = {
          configFile = mkAliasDefinitions options.home.configFile;
          dataFile = mkAliasDefinitions options.home.dataFile;
          userDirs = {
            enable = true;
            desktop = "${config.user.home}/Desk";
            documents = "${config.user.home}/Docs";
            download = "${config.user.home}/Downs";
            music = "${config.user.home}/Tunes";
            pictures = "${config.user.home}/Pics";
            videos = "${config.user.home}/Vids";
            extraConfig = {
              XDG_CODE = "$HOME/Code";
              XDG_GIT = "$HOME/Gits";
            };
          };
        };
      };
    };

    users.users.${config.user.name} = mkAliasDefinitions options.user;

    # Immutable users due to tmpfs
    users.mutableUsers = false;

    # user.initialPassword = if (pathExists passPath) then builtins.fileContents passPath else "nixos"; 

    nix = let users = [ "root" config.user.name ];
    in {
      trustedUsers = users;
      allowedUsers = users;
    };

    # must already begin with pre-existing PATH. Also, can't use binDir here,
    # because it contains a nix store path.
    env.PATH = [ "$DOTFILES_BIN" "$XDG_BIN_HOME" "$PATH" ];

    environment.extraInit = concatStringsSep "\n"
      (mapAttrsToList (n: v: ''export ${n}="${v}"'') config.env);
  };
}
