{
  systemd.user.sessionVariables = {
    # Force XDG Compliance
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
}
