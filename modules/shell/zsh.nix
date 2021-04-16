{ inputs, config, options, pkgs, lib, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.shell.zsh;
  configDir = config.dotfiles.configDir;
  lang = config.modules.dev.lang;
  vcs = config.modules.dev.vcs;
  editor = config.modules.editor;
in {
  options.modules.shell.zsh = with types; {
    enable = mkBoolOpt false;

    aliases = mkOpt (attrsOf (either str path)) { };

    rcInit = mkOpt' lines "" ''
      Zsh lines to be written to $XDG_CONFIG_HOME/zsh/extra.zshrc and sourced by
      $XDG_CONFIG_HOME/zsh/.zshrc
    '';
    envInit = mkOpt' lines "" ''
      Zsh lines to be written to $XDG_CONFIG_HOME/zsh/extra.zshenv and sourced
      by $XDG_CONFIG_HOME/zsh/.zshenv
    '';

    rcFiles = mkOpt (listOf (either str path)) [ ];
    envFiles = mkOpt (listOf (either str path)) [ ];
  };

  config = mkIf cfg.enable {
    users.defaultUserShell = pkgs.zsh;

    programs.zsh.enable = true;

    home.configFile = {
      "zsh/.zshrc".text = ''
        # create a zkbd compatible hash;
        # to add other keys to this hash, see: man 5 terminfo
        typeset -g -A key
        typeset -g HISTDB_FILE="$HOME/.local/share/zsh/histdb/zsh-history.db"
        typeset -U path cdpath fpath manpath

        fpath=(~/.local/share/zsh/scripts "''${fpath[@]}")
        autoload -Uz $fpath[1]/*(.:t) compinit up-line-or-beginning-search down-line-or-beginning-search add-zsh-hook

        zle -N up-line-or-beginning-search
        zle -N down-line-or-beginning-search

        for profile in ''${(z)NIX_PROFILES}; do
          fpath+=($profile/share/zsh/site-functions $profile/share/zsh/$ZSH_VERSION/functions $profile/share/zsh/vendor-completions)
        done

        HELPDIR="/nix/store/xdvjgi50hsfqcmjagmjia0z9lawnybfm-zsh-5.8/share/zsh/$ZSH_VERSION/help"

        reset_broken_terminal () {
            printf '%b' '\e[0m\e(B\e)0\017\e[?5l\e7\e[0;0r\e8'
        }

        # Query to pull in the most recent command if anything was found similar
        # in that directory. Otherwise pull in the most recent command used anywhere
        # Give back the command that was used most recently
        _zsh_autosuggest_strategy_histdb_top_fallback() {
            local query="
                select commands.argv from
        	history left join commands on history.command_id = commands.rowid
        	left join places on history.place_id = places.rowid
        	where places.dir LIKE
        	    case when exists(select commands.argv from history
        	    left join commands on history.command_id = commands.rowid
        	    left join places on history.place_id = places.rowid
        	    where places.dir LIKE '$(sql_escape $PWD)%'
        	    AND commands.argv LIKE '$(sql_escape $1)%')
        	        then '$(sql_escape $PWD)%'
        		else '%'
        		end
        	and commands.argv LIKE '$(sql_escape $1)%'
                group by commands.argv
        	order by places.dir LIKE '$(sql_escape $PWD)%' desc,
        	    history.start_time desc
        	limit 1"
        	suggestion=$(_histdb_query "$query")
        }

        ZSH_AUTOSUGGEST_STRATEGY=histdb_top_fallback

        for dump in ~/.zcompdump(N.mh+24); do
        	compinit
        done
        compinit -C

        ################################################
        #                 KEYBINDINGS                  #
        ################################################
        key[Home]="''${terminfo[khome]}"
        key[End]="''${terminfo[kend]}"
        key[Insert]="''${terminfo[kich1]}"
        key[Backspace]="''${terminfo[kbs]}"
        key[Delete]="''${terminfo[kdch1]}"
        key[Up]="''${terminfo[kcuu1]}"
        key[Down]="''${terminfo[kcud1]}"
        key[Left]="''${terminfo[kcub1]}"
        key[Right]="''${terminfo[kcuf1]}"
        key[PageUp]="''${terminfo[kpp]}"
        key[PageDown]="''${terminfo[knp]}"
        key[Shift-Tab]="''${terminfo[kcbt]}"
        key[Control-Left]="''${terminfo[kLFT5]}"
        key[Control-Right]="''${terminfo[kRIT5]}"

        # setup key accordingly
        [[ -n "''${key[Home]}"          ]] && bindkey -- "''${key[Home]}"          beginning-of-line
        [[ -n "''${key[End]}"           ]] && bindkey -- "''${key[End]}"           end-of-line
        [[ -n "''${key[Insert]}"        ]] && bindkey -- "''${key[Insert]}"        overwrite-mode
        [[ -n "''${key[Backspace]}"     ]] && bindkey -- "''${key[Backspace]}"     backward-delete-char
        [[ -n "''${key[Delete]}"        ]] && bindkey -- "''${key[Delete]}"        delete-char
        [[ -n "''${key[Up]}"            ]] && bindkey -- "''${key[Up]}"            up-line-or-beginning-search
        [[ -n "''${key[Down]}"          ]] && bindkey -- "''${key[Down]}"          down-line-or-beginning-search
        [[ -n "''${key[Left]}"          ]] && bindkey -- "''${key[Left]}"          backward-char
        [[ -n "''${key[Right]}"         ]] && bindkey -- "''${key[Right]}"         forward-char
        [[ -n "''${key[PageUp]}"        ]] && bindkey -- "''${key[PageUp]}"        beginning-of-buffer-or-history
        [[ -n "''${key[PageDown]}"      ]] && bindkey -- "''${key[PageDown]}"      end-of-buffer-or-history
        [[ -n "''${key[Shift-Tab]}"     ]] && bindkey -- "''${key[Shift-Tab]}"     reverse-menu-complete
        [[ -n "''${key[Control-Left]}"  ]] && bindkey -- "''${key[Control-Left]}"  backward-word
        [[ -n "''${key[Control-Right]}" ]] && bindkey -- "''${key[Control-Right]}" forward-word

        # Finally, make sure the terminal is in application mode, when zle is
        # active. Only then are the values from $terminfo valid.
        if (( ''${+terminfo[smkx]} && ''${+terminfo[rmkx]} )); then
            autoload -Uz add-zle-hook-widget
            function zle_application_mode_start { echoti smkx }
            function zle_application_mode_stop { echoti rmkx }
            add-zle-hook-widget -Uz zle-line-init zle_application_mode_start
            add-zle-hook-widget -Uz zle-line-finish zle_application_mode_stop
        fi

        # Fish shell autosuggestions for Zsh
        path+="${pkgs.zsh-autosuggestions}"
        fpath+="${pkgs.zsh-autosuggestions}"
        source ${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh

        # Fish shell history-substring-search for Zsh
        path+="${pkgs.zsh-history-substring-search}"
        fpath+="${pkgs.zsh-history-substring-search}"
        source ${pkgs.zsh-history-substring-search}/share/zsh-history-substring-search/zsh-history-substring-search.zsh

        # Reminds you to use existing aliases for commands you just typed
        path+="${pkgs.zsh-you-should-use}"
        fpath+="${pkgs.zsh-you-should-use}"
        source ${pkgs.zsh-you-should-use}/share/zsh/plugins/you-should-use/you-should-use.plugin.zsh 

        # Fish shell like syntax highlighting
        path+="${pkgs.zsh-fast-syntax-highlighting}"
        fpath+="${pkgs.zsh-fast-syntax-highlighting}"
        source ${pkgs.zsh-fast-syntax-highlighting}/share/zsh/site-functions/fast-syntax-highlighting.plugin.zsh

        # JQ Plugin
        path+="${inputs.zsh-jq}"
        fpath+="${inputs.zsh-jq}"
        source ${inputs.zsh-jq}/jq.plugin.zsh

        # HistDB
        path+="${inputs.zsh-histdb}"
        fpath+="${inputs.zsh-histdb}"

        source ${inputs.zsh-histdb}/zsh-histdb.plugin.zsh
        # Completions
        path+="${pkgs.zsh-completions}"
        fpath+="${pkgs.zsh-completions}"

        ${optionalString (vcs.git.enable) ''
          ${vcs.git.zsh_plugin_text}
        ''}

        ${optionalString (lang.node.enable) ''
          ${lang.node.zsh_plugin_text}
        ''}

        ${optionalString (lang.python.enable) ''
          ${lang.python.zsh_plugin_text}
        ''}

        ${optionalString (lang.rust.enable) ''
          ${lang.ruby.zsh_plugin_text}
        ''}

        ${optionalString (lang.rust.enable) ''
          ${lang.rust.zsh_plugin_text}
        ''}

	${optionalString (editor.nvim.enable) ''
          ${editor.nvim.zsh_plugin_text}
        ''}

        # Environment variables
        . "/etc/profiles/per-user/doc/etc/profile.d/hm-session-vars.sh"
        ################################################
        #                 ENVIRONMENT                  #
        ################################################
        # History options should be set in .zshrc and after oh-my-zsh sourcing.
        # See https://github.com/nix-community/home-manager/issues/177.
        setopt always_to_end        # move cursor to end if word had one match
        #setopt auto_cd              # cd by typing directory name if it's not a command
        setopt auto_list            # automatically list choices on ambiguous completion
        setopt auto_menu            # automatically use menu completion
        setopt correct_all          # autocorrect commands

        HISTFILE=~/.local/share/zsh/zsh_history
        HISTSIZE=10000
        SAVEHIST=10000

        unsetopt nomatch
        setopt append_history
        setopt hist_ignore_all_dups # remove older duplicate entries from history
        setopt hist_reduce_blanks   # remove superfluous blanks from history items
        setopt inc_append_history   # save history entries as soon as they are entered
        setopt share_history        # share history between different instances
        setopt correct_all          # autocorrect commands
        setopt interactive_comments # allow comments in interactive shells
        setopt complete_aliases     # autocomplete for aliases

        # Aliases
        alias ..='cd ..'
        alias 000='chmod -R 000'
        alias 644='chmod -R 644'
        alias 666='chmod -R 666'
        alias 755='chmod -R 755'
        alias 777='chmod -R 777'
        alias ali='alias | bat --style=numbers,grid -l cpp'
        alias blame='systemd-analyze blame'
        alias boot='systemd-analyze'
        alias c='clear'
        alias clone='git clone'
        alias countfiles='fd -t f | wc -l'
        alias diskspace='du -S | sort -n -r | less'
        alias f='fd . | grep '
        alias folders='du -h --max-depth=1'
        alias folderssort='fd . -d 1 -t d -print0 | xargs -0 du -sk | sort -rn'
        alias gt='cd $(fd -H -t d -j $(nproc) | sk )'
        alias h='history | grep '
        alias l='exa --icons'
        alias ls='exa --icons'
        alias la='exa --all --icons'
        alias ll='exa --long --header --git --icons'
        alias lsa='exa --all --icons'
        alias lsal='exa --long --all --header --git --icons'
        alias lsl='exa --long --header --git --icons'
        alias lsla='exa --long --all --header --git --icons'
        alias mem='free -h --si'
        alias mkbz2='tar -cvjf'
        alias mkgz='tar -cvzf'
        alias mktar='tar -cvf'
        alias mountedinfo='df -hT'
	alias ngr='sudo nginx -s reload'
	alias nrfb='sudo nixos-rebuild --flake "/persist/etc/nixos#tardis" boot'
        alias openports='netstat -nape --inet'
        alias p='ps aux | grep '
        alias play='mpv --hwdec=auto'
        alias poweroff='sudo systemctl poweroff'
        alias reboot='sudo systemctl reboot'
        alias sl='exa --icons'
        alias sla='exa --all --icons'
        alias slal='exa --long --all --header --git --icons'
        alias sll='exa --long --header --git --icons'
        alias slla='exa --long --all --header --git --icons'
        alias sudoenv='sudo env PATH=$PATH'
        alias topcpu='ps -eo pcpu,pid,user,args | sort -k 1 -r | head -10'
        alias tree='tree -CAhF --dirsfirst'
        alias treed='tree -CAFd'
        alias tst='hyperfine'
        alias tstc='hyperfine --prepare "sync; echo 3 | sudo tee /proc/sys/vm/drop_caches"'
        alias tstw='hyperfine -w 10'
        alias unbz2='tar -xvjf'
        alias ungz='tar -xvzf'
        alias untar='tar -xvf'
        alias usdspc='sudo compsize /nix /persist /.snapshots /var/log'
        alias x='chmod +x'
        alias xo='xdg-open &>/dev/null'
        alias wget='wget --hsts-file="$XDG_CACHE_HOME/wget-hsts"'

        if [[ $TERM != "dumb" && (-z $INSIDE_EMACS || $INSIDE_EMACS == "vterm") ]]; then
            eval "$(${pkgs.zoxide}/bin/zoxide init zsh )"
            eval "$(${pkgs.starship}/bin/starship init zsh)"
            ${optionalString (lang.nix.enable) ''eval "$(direnv hook zsh)"''}
        fi
              '';
      "zsh/.zlogin".text = ''
        {
          # Compile zcompdump, if modified, to increase startup speed.
          zcompdump="''${ZDOTDIR:-$HOME}/.zcompdump"
          if [[ -s "$zcompdump" && (! -s "''${zcompdump}.zwc" || "$zcompdump" -nt "''${zcompdump}.zwc") ]]; then
            zcompile "$zcompdump"
          fi
        } &!
              '';
      "zsh/.zprofile".text = ''
        {
          # Compile zcompdump, if modified, to increase startup speed.
          zcompdump="''${ZDOTDIR:-$HOME}/.zcompdump"
          if [[ -s "$zcompdump" && (! -s "''${zcompdump}.zwc" || "$zcompdump" -nt "''${zcompdump}.zwc") ]]; then
            zcompile "$zcompdump"
          fi
        } &!
              '';
    };

    user.packages = with pkgs; [
      zsh
      nix-zsh-completions
      zsh-autosuggestions
      zsh-fast-syntax-highlighting
      zsh-history-substring-search
      zsh-you-should-use
      starship
      zoxide
      sqlite
    ];

    env = {
      ZDOTDIR = "$XDG_CONFIG_HOME/zsh";
      ZSH_CACHE = "$XDG_CACHE_HOME/zsh";
    };
  };
}
