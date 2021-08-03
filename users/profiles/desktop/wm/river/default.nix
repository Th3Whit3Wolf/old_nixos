{ pkgs, ... }: {
  xdg.configFile.".river/init".source = ./init;
  xdg.configFile.".river/layout".source = ./layout;
  home.packages = [
    alacritty
    #brightnessctl
    wofi
    kanshi
    swaylock-effects
    swayidle
    grim
    sway-contrib.grimshot
    imv
    slurp
    qt5.qtwayland
    nwg-launchers
    wl-clipboard
    mpv
  ];
}
