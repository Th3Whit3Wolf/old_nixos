{
  programs.ZSH = {
    enable = true;
    enableAutosuggestions = true;
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
      nix-index = true;
      starship = true;
      zoxide = true;
    };
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
        nrfb = "sudo nixos-rebuild --flake \"/persist/etc/nixos#tardis\" boot";
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
        tstc = "hyperfine --prepare \"sync; echo 3 | sudo tee /proc/sys/vm/drop_caches\"";
        tstw = "hyperfine -w 10";
        unbz2 = "tar -xvjf";
        ungz = "tar -xvzf";
        untar = "tar -xvf";
        usdspc = "sudo compsize /nix /persist /.snapshots /var/log";
        x = "chmod +x";
        xo = "xdg-open &>/dev/null";
        wget = "wget --hsts-file=\"$XDG_CACHE_HOME/wget-hsts\"";
    };
  };
}
