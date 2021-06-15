{ config, lib, pkgs, ... }:

let
  inherit (config.home) homeDirectory username;

  npg = config.nix-polyglot;
  xdg = config.xdg;
  relToHome = xdgDir: builtins.substring  (builtins.stringLength homeDirectory)  (builtins.stringLength xdgDir) xdgDir;

  conf = if xdg.enable then  (relToHome xdg.configHome) else ".config";
  cache = if xdg.enable then  (relToHome xdg.cacheHome) else ".cache";
  data = if xdg.enable then  (relToHome xdg.dataHome) else ".local/share";
  desktop = if xdg.userDirs.enable then  (relToHome xdg.userDirs.desktop) else "Desktop";
  documents = if xdg.userDirs.enable then  (relToHome xdg.userDirs.documents) else "Documents";
  download = if xdg.userDirs.enable then  (relToHome xdg.userDirs.download) else "Downloads";
  music = if xdg.userDirs.enable then  (relToHome xdg.userDirs.music) else "Music";
  pictures = if xdg.userDirs.enable then  (relToHome xdg.userDirs.pictures) else "Pictures";
  publicShare = if xdg.userDirs.enable then  (relToHome xdg.userDirs.publicShare) else "Public";
  templates = if xdg.userDirs.enable then  (relToHome xdg.userDirs.templates) else "Templates";
  videos = if xdg.userDirs.enable then  (relToHome xdg.userDirs.videos) else "Videos";
  extraUserDirs = if xdg.userDirs.enable then (lib.attrsets.mapAttrsToList (name: value: relToHome "${value}") xdg.userDirs.extraConfig) else [];

  vscodePname = npg.vscode.package.pname;
  vscodeConfigDir = {
    "vscode" = "Code";
    "vscode-insiders" = "Code - Insiders";
    "vscodium" = "VSCodium";
  }.${vscodePname};
  vscodeExtensionDir = {
    "vscode" = ".vscode";
    "vscode-insiders" = ".vscode-insiders";
    "vscodium" = ".vscode-oss";
  }.${vscodePname};

in
{
  home.persistence."/persist/${homeDirectory}" = {
    directories = [
      "${cache}/gstreamer-1.0"
      "${cache}/lollypop"
      "${cache}/nix-index"
      "${conf}/pipewire/media-session.d"
      ".gnupg"
      "${data}/direnv"
      "${data}/gnupg"
      "${data}/icons"
      "${data}/keyrings"
      "${data}/lollypop"
      "${data}/nu"
      "${data}/themes"
      "${data}/Trash"
      "${desktop}"
      "${documents}"
      "${download}"
      "${pictures}"
      "${publicShare}"
      "${templates}"
      "${videos}"
      ".ssh"
    ] 
    ++ extraUserDirs
    ++ lib.optionals (npg.vscode.enable) [
      "${conf}/pipewire/media-session.d"
      "${conf}/${vscodeConfigDir}/Service Worker"
      "${conf}/.pki"
      "${vscodeExtensionDir}"
    ]
    ++ lib.optionals (npg.neovim.enable) [
      "${data}/nvim"
    ]
    ++ lib.optionals (npg.lang.rust.enable) [
      "${data}/cargo"
      "${data}/rustup"
    ]
    ++ lib.optionals (config.programs.firefox.enable) [
      ".mozilla/firefox"
    ]
    ++ lib.optionals (config.programs.ZSH.enable) [
      "${cache}/zsh/"
      "${data}/zsh"
    ]
    ++ lib.optionals (config.programs.ZSH.integrations.zoxide.enable) [
      "${data}/zoxide"
    ]
    ++ lib.optionals (config.programs.ZSH.integrations.starship.enable) [
      "${cache}/starship"
    ];


    files = [] ++ lib.optionals (npg.vscode.enable) [
      "${conf}/${vscodeConfigDir}/QuotaManager"
      "${conf}/${vscodeConfigDir}/QuotaManager-journal"
    ];

    allowOther = true;
  };

}
