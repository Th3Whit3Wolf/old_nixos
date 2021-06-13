{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.ZSH;
  polyglot = config.nix-polyglot;
  PATH = if (cfg.pathVar != []) then ''
typeset -U PATH path

path=(${concatMapStrings (x: "\n    \"" + x + "\"") cfg.pathVar }
    "$path[@]"
)

export PATH
'' else '''';

  neovimAliases = if polyglot.enableZshIntegration then ''
# Open lazygit commit window inside neovim
if [ -n "$NVIM_LISTEN_ADDRESS" ]; then
  alias nvim="nvr -cc split --remote-wait +'set bufhidden=wipe'"
  alias vim="nvr -cc split --remote-wait +'set bufhidden=wipe'"
  alias vi="nvr -cc split --remote-wait +'set bufhidden=wipe'"
  alias v="nvr -cc split --remote-wait +'set bufhidden=wipe'"
else
  alias vim="nvim"
  alias vi="nvim"
  alias v="nvim"
fi
if [ -n "$NVIM_LISTEN_ADDRESS" ]; then
    export EDITOR="nvr -cc split --remote-wait +'set bufhidden=wipe'"
else
    export EDITOR="nvim"
fi
'' else ''
# Open lazygit commit window inside neovim
if [ -n "$NVIM_LISTEN_ADDRESS" ]; then
  alias nvim="nvr -cc split --remote-wait +'set bufhidden=wipe'"
fi
if [ -n "$NVIM_LISTEN_ADDRESS" ]; then
    export EDITOR="nvr -cc split --remote-wait +'set bufhidden=wipe'"
else
    export EDITOR="nvim"
fi
'';



  keychainFlags = config.programs.keychain.extraFlags ++ optional (config.programs.keychain.agents != [ ])
    "--agents ${concatStringsSep "," config.programs.keychain.agents}"
    ++ optional (config.programs.keychain.inheritType != null) "--inherit ${config.programs.keychain.inheritType}";

  keychainShellCommand =
    "${pkgs.keychain}/bin/keychain --eval ${concatStringsSep " " keychainFlags} ${
      concatStringsSep " " config.programs.keychain.keys
    }";

  relToDotDir = file: "${config.xdg.configHome}/zsh/" + file;

  pluginsDir = relToDotDir "plugins";
  siteFunctionDir = relToDotDir "site-functions";

  envVarsStr = config.lib.zsh.exportAll cfg.sessionVariables;
  localVarsStr = config.lib.zsh.defineAll cfg.localVariables;

  aliasesStr = concatStringsSep "\n" (
    mapAttrsToList (k: v: "alias ${k}=${lib.escapeShellArg v}") cfg.shellAliases
  );

  globalAliasesStr = concatStringsSep "\n" (
    mapAttrsToList (k: v: "alias -g ${k}=${lib.escapeShellArg v}") cfg.shellGlobalAliases
  );

  dirHashesStr = concatStringsSep "\n" (
    mapAttrsToList (k: v: ''hash -d ${k}="${v}"'') cfg.dirHashes
  );

  zdotdir = "$HOME/.config.zsh";

  bindkeyCommands = {
    emacs = "bindkey -e";
    viins = "bindkey -v";
    vicmd = "bindkey -a";
  };

  stateVersion = config.home.stateVersion;

  historyModule = types.submodule ({ config, ... }: {
    options = {
      size = mkOption {
        type = types.int;
        default = 10000;
        description = "Number of history lines to keep.";
      };

      save = mkOption {
        type = types.int;
        defaultText = 10000;
        default = config.size;
        description = "Number of history lines to save.";
      };

      path = mkOption {
        type = types.str;
        default = if versionAtLeast stateVersion "20.03"
          then "$HOME/.zsh_history"
          else relToDotDir ".zsh_history";
        defaultText = literalExample ''
          "$HOME/.zsh_history" if state version ≥ 20.03,
          "$ZDOTDIR/.zsh_history" otherwise
        '';
        example = literalExample ''"''${config.xdg.dataHome}/zsh/zsh_history"'';
        description = "History file location";
      };

      ignorePatterns = mkOption {
        type = types.listOf types.str;
        default = [];
        example = literalExample ''[ "rm *" "pkill *" ]'';
        description = ''
          Do not enter command lines into the history list
          if they match any one of the given shell patterns.
        '';
      };

      ignoreDups = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Do not enter command lines into the history list
          if they are duplicates of the previous event.
        '';
      };

      ignoreSpace = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Do not enter command lines into the history list
          if the first character is a space.
        '';
      };

      expireDuplicatesFirst = mkOption {
        type = types.bool;
        default = false;
        description = "Expire duplicates first.";
      };

      extended = mkOption {
        type = types.bool;
        default = false;
        description = "Save timestamp into the history file.";
      };

      share = mkOption {
        type = types.bool;
        default = true;
        description = "Share command history between zsh sessions.";
      };
    };
  });

  integrationsModule = types.submodule ({ config, ... }: {
    options = {
      autojump = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to enable autojump integration.";
      };
      broot = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to enable broot integration.";
      };
      dircolors = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to enable dircolors integration.";
      };
      direnv = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to enable direnv integration.";
      };
      fzf = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to enable fzf integration.";
      };
      keychain = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to enable keychain integration.";
      };
      mcfly = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to enable mcfly integration.";
      };
      nix-index = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to enable nix-index integration.";
      };
      opam = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to enable opam integration.";
      };
      pazi = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to enable pazi integration.";
      };
      scmpuff = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to enable scmpuff integration.";
      };
      skim = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to enable skim integration.";
      };
      starship = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to enable startship integration.";
      };
      z-lua = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to enable z-lua integration.";
      };
      zoxide = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to enable zoxide integration.";
      };
    };
  });

  sitefunctionModule = types.submodule ({ config, ... }: {
    options = {
      src = mkOption {
        type = types.path;
        description = ''
          Path to the completion file.
        '';
      };

      name = mkOption {
        type = types.str;
        description = ''
          The name of the completion.
        '';
      };
    };
  });

  pluginModule = types.submodule ({ config, ... }: {
    options = {
      src = mkOption {
        type = types.path;
        description = ''
          Path to the plugin folder.

          Will be added to <envar>fpath</envar> and <envar>PATH</envar>.
        '';
      };

      name = mkOption {
        type = types.str;
        description = ''
          The name of the plugin.

          Don't forget to add <option>file</option>
          if the script name does not follow convention.
        '';
      };

      file = mkOption {
        type = types.str;
        description = "The plugin script to source.";
      };
    };

    config.file = mkDefault "${config.name}.plugin.zsh";
  });

in

{
  options = {
    programs.ZSH = {
      enable = mkEnableOption "Z shell (Zsh)";

      autocd = mkOption {
        default = null;
        description = ''
          Automatically enter into a directory if typed directly into shell.
        '';
        type = types.nullOr types.bool;
      };

      cdpath = mkOption {
        default = [];
        description = ''
          List of paths to autocomplete calls to `cd`.
        '';
        type = types.listOf types.str;
      };

      dotDir = mkOption {
        default = null;
        example = ".config/zsh";
        description = ''
          Directory where the zsh configuration and more should be located,
          relative to the users home directory. The default is the home
          directory.
        '';
        type = types.nullOr types.str;
      };

      shellAliases = mkOption {
        default = {};
        example = literalExample ''
          {
            ll = "ls -l";
            ".." = "cd ..";
          }
        '';
        description = ''
          An attribute set that maps aliases (the top level attribute names in
          this option) to command strings or directly to build outputs.
        '';
        type = types.attrsOf types.str;
      };

      pathVar = mkOption {
        default = [];
        description = ''
          List of paths added to PATH variable.
        '';
        type = types.listOf types.str;
      };

      shellGlobalAliases = mkOption {
        default = {};
        example = literalExample ''
          {
            UUID = "$(uuidgen | tr -d \\n)";
            G = "| grep";
          }
        '';
        description = ''
          Similar to <varname><link linkend="opt-programs.zsh.shellAliases">opt-programs.zsh.shellAliases</link></varname>,
          but are substituted anywhere on a line.
        '';
        type = types.attrsOf types.str;
      };

      dirHashes = mkOption {
        default = {};
        example = literalExample ''
          {
            docs  = "$HOME/Documents";
            vids  = "$HOME/Videos";
            dl    = "$HOME/Downloads";
          }
        '';
        description = ''
          An attribute set that adds to named directory hash table.
        '';
        type = types.attrsOf types.str;
      };

      enableCompletion = mkOption {
        default = true;
        description = ''
          Enable zsh completion. Don't forget to add
          <programlisting language="nix">
            environment.pathsToLink = [ "/share/zsh" ];
          </programlisting>
          to your system configuration to get completion for system packages (e.g. systemd).
        '';
        type = types.bool;
      };

      enableAutosuggestions = mkOption {
        default = true;
        description = "Enable zsh autosuggestions";
      };

      history = mkOption {
        type = historyModule;
        default = {};
        description = "Options related to commands history configuration.";
      };

      integrations = mkOption {
        type = integrationsModule;
        default = {};
        description = "Options related to integrations configuration.";
      };

      defaultKeymap = mkOption {
        type = types.nullOr (types.enum (attrNames bindkeyCommands));
        default = null;
        example = "emacs";
        description = "The default base keymap to use.";
      };

      sessionVariables = mkOption {
        default = {};
        type = types.attrs;
        example = { MAILCHECK = 30; };
        description = "Environment variables that will be set for zsh session.";
      };

      initExtraBeforeCompInit = mkOption {
        default = "";
        type = types.lines;
        description = "Extra commands that should be added to <filename>.zshrc</filename> before compinit.";
      };

      initExtra = mkOption {
        default = "";
        type = types.lines;
        description = "Extra commands that should be added to <filename>.zshrc</filename>.";
      };

      initExtraFirst = mkOption {
        default = "";
        type = types.lines;
        description = "Commands that should be added to top of <filename>.zshrc</filename>.";
      };

      envExtra = mkOption {
        default = "";
        type = types.lines;
        description = "Extra commands that should be added to <filename>.zshenv</filename>.";
      };

      profileExtra = mkOption {
        default = "";
        type = types.lines;
        description = "Extra commands that should be added to <filename>.zprofile</filename>.";
      };

      loginExtra = mkOption {
        default = "";
        type = types.lines;
        description = "Extra commands that should be added to <filename>.zlogin</filename>.";
      };

      logoutExtra = mkOption {
        default = "";
        type = types.lines;
        description = "Extra commands that should be added to <filename>.zlogout</filename>.";
      };

      sitefunctions = mkOption {
        type = types.listOf sitefunctionModule;
        default = {};
        description = ''
          Attribute set of files to link into the user's $ZDOTDIR/site-function/
        '';
      };

      plugins = mkOption {
        type = types.listOf pluginModule;
        default = [];
        example = literalExample ''
          [
            {
              # will source zsh-autosuggestions.plugin.zsh
              name = "zsh-autosuggestions";
              src = pkgs.fetchFromGitHub {
                owner = "zsh-users";
                repo = "zsh-autosuggestions";
                rev = "v0.4.0";
                sha256 = "0z6i9wjjklb4lvr7zjhbphibsyx51psv50gm07mbb0kj9058j6kc";
              };
            }
            {
              name = "enhancd";
              file = "init.sh";
              src = pkgs.fetchFromGitHub {
                owner = "b4b4r07";
                repo = "enhancd";
                rev = "v2.2.1";
                sha256 = "0iqa9j09fwm6nj5rpip87x3hnvbbz9w9ajgm6wkrd5fls8fn8i5g";
              };
            }
          ]
        '';
        description = "Plugins to source in <filename>.zshrc</filename>.";
      };

      localVariables = mkOption {
        type = types.attrs;
        default = {};
        example = { POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=["dir" "vcs"]; };
        description = ''
          Extra local variables defined at the top of <filename>.zshrc</filename>.
        '';
      };
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
        home.file = {
            "${relToDotDir ".zlogin"}".text = ''
                {
                # Compile zcompdump, if modified, to increase startup speed.
                zcompdump="''$XDG_CACHE_HOME/zsh/zcompdump"
                if [[ -s "$zcompdump" && (! -s "''${zcompdump}.zwc" || "$zcompdump" -nt "''${zcompdump}.zwc") ]]; then
                    zcompile "$zcompdump"
                fi
                } &!
                ${optionalString (cfg.loginExtra != null) cfg.loginExtra}
            '';

            "${relToDotDir ".zprofile"}".text = ''
                {
                # Compile zcompdump, if modified, to increase startup speed.
                zcompdump="''$XDG_CACHE_HOME/zsh/zcompdump"
                if [[ -s "$zcompdump" && (! -s "''${zcompdump}.zwc" || "$zcompdump" -nt "''${zcompdump}.zwc") ]]; then
                    zcompile "$zcompdump"
                fi
                } &!
                ${optionalString (cfg.profileExtra != null) cfg.profileExtra}
            '';
            "${relToDotDir ".zshenv"}".text = ''
              # Environment variables
              . "${config.home.profileDirectory}/etc/profile.d/hm-session-vars.sh"
              ${envVarsStr}
              ${cfg.envExtra}
              ${PATH}
              '';
        };
    }

    (mkIf (cfg.logoutExtra != "") {
      home.file."${relToDotDir ".zlogout"}".text = cfg.logoutExtra;
    })

    {
      home.packages = with pkgs; [ zsh ]
        ++ optional cfg.enableCompletion nix-zsh-completions;

      home.file."${relToDotDir ".zshrc"}".text = ''        
${cfg.initExtraFirst}
typeset -g -A key
typeset -U path cdpath fpath manpath

${optionalString (cfg.cdpath != []) ''
  cdpath+=(${concatStringsSep " " cfg.cdpath})
''}

autoload -Uz $fpath[1]/*(.:t) compinit up-line-or-beginning-search down-line-or-beginning-search add-zsh-hook

zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

for profile in ''${(z)NIX_PROFILES}; do
  fpath+=($profile/share/zsh/site-functions $profile/share/zsh/$ZSH_VERSION/functions $profile/share/zsh/vendor-completions)
done

reset_broken_terminal () {
    printf '%b' '\e[0m\e(B\e)0\017\e[?5l\e7\e[0;0r\e8'
}
HELPDIR="${pkgs.zsh}/share/zsh/$ZSH_VERSION/help"

${optionalString (cfg.defaultKeymap != null) ''
  # Use ${cfg.defaultKeymap} keymap as the default.
  ${getAttr cfg.defaultKeymap bindkeyCommands}
''}

${localVarsStr}

${cfg.initExtraBeforeCompInit}

${concatStrings (map (plugin: ''
  path+="$HOME/${pluginsDir}/${plugin.name}"
  fpath+="$HOME/${pluginsDir}/${plugin.name}"
'') cfg.plugins)}

${optionalString (cfg.sitefunctions != []) "fpath+=${siteFunctionDir}"}

for dump in $XDG_CACHE_HOME/zsh/(N.mh+24); do
    compinit -d $dump
done

${optionalString (cfg.enableAutosuggestions) "source ${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh"}
${optionalString (cfg.integrations.autojump)". ${pkgs.autojump}/share/autojump/autojump.zsh"}
${optionalString (cfg.integrations.broot)''
# This script was automatically generated by the broot function
# More information can be found in https://github.com/Canop/broot
# This function starts broot and executes the command
# it produces, if any.
# It's needed because some shell commands, like `cd`,
# have no useful effect if executed in a subshell.
function br {
    f=$(mktemp)
    (
        set +e
        broot --outcmd "$f" "$@"
        code=$?
        if [ "$code" != 0 ]; then
            rm -f "$f"
            exit "$code"
        fi
    )
    code=$?
    if [ "$code" != 0 ]; then
        return "$code"
    fi
    d=$(cat "$f")
    rm -f "$f"
    eval "$d"
}''
}
${optionalString (cfg.integrations.dircolors)''eval $(${pkgs.coreutils}/bin/dircolors -c ~/.dir_colors)''}
${optionalString (cfg.integrations.direnv)''eval "$(${pkgs.direnv}/bin/direnv hook zsh)"''}
${optionalString (cfg.integrations.fzf)''
if [[ $options[zle] = on ]]; then
  . ${pkgs.fzf}/share/fzf/completion.zsh
  . ${pkgs.fzf}/share/fzf/key-bindings.zsh
fi
''}
${optionalString (cfg.integrations.keychain)''eval "$(${keychainShellCommand})"''}
${optionalString (cfg.integrations.mcfly)"source ${pkgs.mcfly}/share/mcfly/mcfly.zsh"}
${optionalString (cfg.integrations.nix-index)"source ${pkgs.nix-index}/etc/profile.d/command-not-found.sh"}
${optionalString (cfg.integrations.opam)''eval "$(${pkgs.opam}/bin/opam env --shell=zsh)"''}
${optionalString (cfg.integrations.pazi)''eval "$(${pkgs.pazi}/bin/pazi init zsh)"''}
${optionalString (cfg.integrations.scmpuff)''eval "$(${pkgs.scmpuff}/bin/scmpuff init -s)"''}
${optionalString (cfg.integrations.skim)''
if [[ $options[zle] = on ]]; then
    . ${pkgs.skim}/share/skim/completion.zsh
    . ${pkgs.skim}/share/skim/key-bindings.zsh
fi
''}
${optionalString (cfg.integrations.starship)''
if [[ $TERM != "dumb" && (-z $INSIDE_EMACS || $INSIDE_EMACS == "vterm") ]]; then
        eval "$(${pkgs.starship}/bin/starship init zsh)"
fi
''}
${optionalString (cfg.integrations.z-lua )''eval "$(${pkgs.z-lua}/bin/z --init zsh)"''}
${optionalString (cfg.integrations.zoxide)''eval "$(${pkgs.zoxide}/bin/zoxide init zsh)"''}

${concatStrings (map (plugin: ''
  if [ -f "$HOME/${pluginsDir}/${plugin.name}/${plugin.file}" ]; then
    source "$HOME/${pluginsDir}/${plugin.name}/${plugin.file}"
  fi
'') cfg.plugins)}

# History options should be set in .zshrc and after oh-my-zsh sourcing.
# See https://github.com/nix-community/home-manager/issues/177.
HISTSIZE="${toString cfg.history.size}"
SAVEHIST="${toString cfg.history.save}"
${optionalString (cfg.history.ignorePatterns != []) "HISTORY_IGNORE=${lib.escapeShellArg "(${lib.concatStringsSep "|" cfg.history.ignorePatterns})"}"}
${if versionAtLeast config.home.stateVersion "20.03"
  then ''HISTFILE="${cfg.history.path}"''
  else ''HISTFILE="$HOME/${cfg.history.path}"''}
mkdir -p "$(dirname "$HISTFILE")"

setopt HIST_FCNTL_LOCK
${if cfg.history.ignoreDups then "setopt" else "unsetopt"} HIST_IGNORE_DUPS
${if cfg.history.ignoreSpace then "setopt" else "unsetopt"} HIST_IGNORE_SPACE
${if cfg.history.expireDuplicatesFirst then "setopt" else "unsetopt"} HIST_EXPIRE_DUPS_FIRST
${if cfg.history.share then "setopt" else "unsetopt"} SHARE_HISTORY
${if cfg.history.extended then "setopt" else "unsetopt"} EXTENDED_HISTORY
${if cfg.autocd != null then "${if cfg.autocd then "setopt" else "unsetopt"} autocd" else ""}
zstyle ':completion:*' cache-path $XDG_CACHE_HOME/zsh/zcompcache

${cfg.initExtra}

# Finally, make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.
if (( ''${+terminfo[smkx]} && ''${+terminfo[rmkx]} )); then
    autoload -Uz add-zle-hook-widget
    function zle_application_mode_start { echoti smkx }
    function zle_application_mode_stop { echoti rmkx }
    add-zle-hook-widget -Uz zle-line-init zle_application_mode_start
    add-zle-hook-widget -Uz zle-line-finish zle_application_mode_stop
fi

${optionalString (polyglot.neovim.enable) neovimAliases}
# Aliases
${aliasesStr}

# Global Aliases
${globalAliasesStr}

# Named Directory Hashes
${dirHashesStr}
      '';
    }

    (mkIf cfg.integrations.autojump {
      programs.autojump.enable = true;
    })
    
    (mkIf cfg.integrations.broot {
      programs.broot.enable = true;
    })

    (mkIf cfg.integrations.dircolors {
      programs.dircolors.enable = true;
    })

    (mkIf cfg.integrations.direnv {
      programs.direnv.enable = true;
    })

    (mkIf cfg.integrations.fzf {
      programs.fzf.enable = true;
    })

    (mkIf cfg.integrations.keychain {
      programs.keychain.enable = true;
    })

    (mkIf cfg.integrations.mcfly {
      programs.mcfly.enable = true;
    })

    (mkIf cfg.integrations.nix-index {
      programs.nix-index.enable = true;
    })

    (mkIf cfg.integrations.opam {
      programs.opam.enable = true;
    })

    (mkIf cfg.integrations.pazi {
      programs.pazi.enable = true;
    })

    (mkIf cfg.integrations.scmpuff {
      programs.scmpuff.enable = true;
    })

    (mkIf cfg.integrations.skim {
      programs.skim.enable = true;
    })

    (mkIf cfg.integrations.starship {
      programs.starship.enable = true;
    })

    (mkIf cfg.integrations.z-lua {
      programs.z-lua.enable = true;
    })

    (mkIf cfg.integrations.zoxide {
      programs.zoxide.enable = true;
    })

    (mkIf (cfg.plugins != []) {
      # Many plugins require compinit to be called
      # but allow the user to opt out.
      programs.ZSH.enableCompletion = mkDefault true;

      home.file =
        foldl' (a: b: a // b) {}
        (map (plugin: { "${pluginsDir}/${plugin.name}".source = plugin.src; })
        cfg.plugins);
    })

    (mkIf (cfg.sitefunctions  != []) {
      home.file =
      foldl' (a: b: a // b) {}
      (map (sitefunctions: { "${siteFunctionDir}/_${sitefunctions.name}".source = sitefunctions.src; })
        cfg.sitefunctions);
    })
  ]);
}