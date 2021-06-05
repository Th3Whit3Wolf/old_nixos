let
  firefox = programs.firefox.enable;
in
{
  xdg.configFile."psd/psd.conf".text = ''
    USE_OVERLAYFS="yes"
    USE_SUSPSYNC="no"
    # this array is left commented.
    #
    # Possible values:
    #  chromium
    #  chromium-dev
    #  conkeror.mozdev.org
    #  epiphany
    #  falkon
    #  firefox
    #  firefox-trunk
    #  google-chrome
    #  google-chrome-beta
    #  google-chrome-unstable
    #  heftig-aurora
    #  icecat
    #  inox
    #  luakit
    #  midori
    #  opera
    #  opera-beta
    #  opera-developer
    #  opera-legacy
    #  otter-browser
    #  qupzilla
    #  qutebrowser
    #  palemoon
    #  rekonq
    #  seamonkey
    #  surf
    #  vivaldi
    #  vivaldi-snapshot
    BROWSERS=(${optionalString (firefox) ''firefox''})
  '';
}
