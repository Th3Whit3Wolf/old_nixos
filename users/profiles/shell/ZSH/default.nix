{ config, lib, pkgs, ... }:

{
  programs.ZSH = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    initExtra = ''
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
    '';
    integrations = {
      # Should be moved to nix-polyglot
      direnv = true;
      nix-index = true;
      starship = true;
      zoxide = true;
    };
    history = { path = "$XDG_CACHE_HOME/zsh/zsh_history"; };
    shellAliases = {
      ".." = "cd ..";
      "000" = "chmod -R 000";
      "644" = "chmod -R 644";
      "666" = "chmod -R 666";
      "755" = "chmod -R 755";
      "777" = "chmod -R 777";
      ali = "alias | bat --style=numbers,grid -l cpp";
      blame = "systemd-analyze blame";
      boot = "systemd-analyze";
      c = "clear";
      clone = "git clone";
      countfiles = "fd -t f | wc -l";
      diskspace = "du -S | sort -n -r | less";
      f = "fd . | grep ";
      folders = "du -h --max-depth=1";
      folderssort = "fd . -d 1 -t d -print0 | xargs -0 du -sk | sort -rn";
      gt = "cd $(fd -H -t d -j $(nproc) | sk )";
      h = "history | grep ";
      l = "exa --icons";
      ls = "exa --icons";
      la = "exa --all --icons";
      ll = "exa --long --header --git --icons";
      lsa = "exa --all --icons";
      lsal = "exa --long --all --header --git --icons";
      lsl = "exa --long --header --git --icons";
      lsla = "exa --long --all --header --git --icons";
      mem = "free -h --si";
      mkbz2 = "tar -cvjf";
      mkgz = "tar -cvzf";
      mktar = "tar -cvf";
      mountedinfo = "df -hT";
      ngr = "sudo nginx -s reload";
      nrfb = "sudo nixos-rebuild --flake /persist/etc/nixos#$(hostname) boot";
      nrfs = "sudo nixos-rebuild --flake /persist/etc/nixos#$(hostname) switch";
      openports = "netstat -nape --inet";
      p = "ps aux | grep ";
      play = "mpv --hwdec=auto";
      poweroff = "sudo systemctl poweroff";
      reboot = "sudo systemctl reboot";
      sl = "exa --icons";
      sla = "exa --all --icons";
      slal = "exa --long --all --header --git --icons";
      sll = "exa --long --header --git --icons";
      slla = "exa --long --all --header --git --icons";
      sudoenv = "sudo env PATH=$PATH";
      topcpu = "ps -eo pcpu,pid,user,args | sort -k 1 -r | head -10";
      tree = "tree -CAhF --dirsfirst";
      treed = "tree -CAFd";
      tst = "hyperfine";
      tstc = ''
        hyperfine --prepare "sync; echo 3 | sudo tee /proc/sys/vm/drop_caches"'';
      tstw = "hyperfine -w 10";
      unbz2 = "tar -xvjf";
      ungz = "tar -xvzf";
      untar = "tar -xvf";
      usdspc = "sudo compsize /nix /persist /.snapshots /var/log";
      x = "chmod +x";
      xo = "xdg-open &>/dev/null";
      wget = ''wget --hsts-file="$XDG_CACHE_HOME/wget-hsts"'';
    };
    scripts = [
      {
        name = "cd";
        text = ''
          if [[ -f $VIRTUAL_ENV/.project && -n "$(< $VIRTUAL_ENV/.project 2>/dev/null)" && -z "$@" ]]; then
              builtin cd $(< $VIRTUAL_ENV/.project) && ${pkgs.exa}/bin/exa
          elif [[ -n "$(git rev-parse --show-toplevel 2>/dev/null)" && "$(pwd)" == "$(git rev-parse --show-toplevel 2>/dev/null)" && -z "$@" ]]; then
              builtin cd ~/ && ${pkgs.exa}/bin/exa
          elif [[ -n "$(git rev-parse --show-toplevel 2>/dev/null)" && -z "$@" ]]; then
              builtin cd $(git rev-parse --show-toplevel) && ${pkgs.exa}/bin/exa
          else
              builtin cd $@ && ${pkgs.exa}/bin/exa
          fi
        '';
      }
      {
        name = "compress";
        text = ''
          if [[ -n "$1" ]]; then
            FILE=$1
            case $FILE in
              *.tar ) shift && tar cf $FILE $* ;;
              *.tar.bz2 ) shift && tar cjf $FILE $* ;;
              *.tar.gz ) shift && tar czf $FILE $* ;;
              *.tgz ) shift && tar czf $FILE $* ;;
              *.zip ) shift && zip $FILE $* ;;
              *.rar ) shift && rar $FILE $* ;;
            esac
          else
            echo "usage: compress <foo.tar.gz> ./foo ./bar"
          fi
        '';
      }
      {
        name = "cp";
        text = ''
          if [[ -z $2 ]]; then
            command cp -rv $1 ./
          else
            command cp -rv $@
          fi
        '';
      }
      {
        name = "gz";
        text = ''
          local origsize=$(wc -c <"$1")
          local gzipsize=$(${pkgs.pigz}/bin/pigz -c "$1" | wc -c)
          local ratio=$(echo "$gzipsize * 100/ $origsize" | ${pkgs.bc} -l)
          printf "orig: %d bytes\n" "$origsize"
          printf "gzip: %d bytes (%2.2f%%)\n" "$gzipsize" "$ratio"
        '';
      }
      {
        name = "httpcompression";
        text = ''
          local encoding="$(${pkgs.curl}/bin/curl -LIs -H 'User-Agent: Mozilla/5 Gecko' -H 'Accept-Encoding: gzip,deflate,compress,sdch' "$1" | grep '^Content-Encoding:')" && echo "$1 is encoded using $\{encoding#* }" || echo "$1 is not using any encoding"
        '';
      }
      {
        name = "mkd";
        text = ''
          mkdir -p "$@" && cd "$@"
        '';
      }
      {
        name = "mv";
        text = ''
          if [[ -z $2 ]]; then
            command mv -v $1 ./
          else
            command mv -v $@
          fi
        '';
      }
      {
        name = "nrfb";
        text = ''
          HOSTNAME=$(hostname)
          TMPSIZE=$(cat /etc/fstab | rg /tmp | tr ',' '\n' | grep size)
          TOTAL_MEM=$(free -h --si | grep Mem | awk '{print $2}')
          MEM_UNITS=$(echo ''${TOTAL_MEM: -1})
          MEM_MINUS_ONE=$(expr $(echo ''${TOTAL_MEM:0:-1}) - 1)
          if [ ! -z "''${HOSTNAME}"]; then
            cd /persist/etc/nixos
            nix flake lock --update-input nix-polyglot
            if [[ ! -z $TMPSIZE ]] && [[ $MEM_MINUS_ONE == ?(-)+([0-9]) ]] && [[ ! -z $MEM_UNITS ]]; then
              echo "Increase size of /tmp"
              sudo mount -o remount,size=''${MEM_MINUS_ONE}''${MEM_UNITS} /tmp
              sudo nixos-rebuild --flake .#''${HOSTNAME} boot
              sudo mount -o remount,''${TMPSIZE} /tmp
            else
              sudo nixos-rebuild --flake .#''${HOSTNAME} boot
            fi
            cd $OLDPWD
          else
            echo hostname not found
          fi
        '';
      }
      {
        name = "up";
        text = ''
          local d=""
          limit=$1
          for ((i=1 ; i <= limit ; i++)); do
            d=$d/..
          done
          d=$(echo $d | sed 's/^\///')
          if [[ -z "$d" ]]; then
            d=..
          fi
          cd $d
        '';
      }
    ];
  };
  services.lorri.enable = config.programs.ZSH.integrations.direnv;
}
