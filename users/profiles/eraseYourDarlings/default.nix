{ config, lib, pkgs, ... }:

with lib;

let
  inherit (config.home) homeDirectory username;

  npg = config.nix-polyglot;
  xdg = config.xdg;
  zsh = config.programs.ZSH;

  startWithHome = xdgDir: if (builtins.substring 0 5 xdgDir) == "$HOME/" then true else false;
  relToHome = xdgDir: if (startWithHome xdgDir) then 
    (builtins.substring 6 (builtins.stringLength xdgDir) xdgDir) 
    else 
    (builtins.substring (builtins.stringLength homeDirectory) (builtins.stringLength xdgDir) xdgDir);

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
  extraUserDirs = if xdg.userDirs.enable then (attrsets.mapAttrsToList (name: value: relToHome "${value}") xdg.userDirs.extraConfig) else [];

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
    allowOther = true;
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
      ".mozilla/firefox"
      #(optionalString (config.programs.firefox.enable) ''firefox'')
    ] 
    ++ extraUserDirs
    ++ optionals (npg.vscode.enable) [
      "${conf}/pipewire/media-session.d"
      "${conf}/${vscodeConfigDir}"
      ".pki"
      "${vscodeExtensionDir}"
    ]
    ++ optionals (npg.neovim.enable) [
      "${data}/nvim"
    ]
    ++ optionals (npg.lang.rust.enable) [
      "${data}/cargo"
      "${data}/rustup"
    ]
    ++ optionals (zsh.enable) [
      "${cache}/zsh/"
      "${data}/zsh"
      (optionalString (zsh.integrations.zoxide)"${data}/zoxide")
      (optionalString (zsh.integrations.starship)"${cache}/starship")
    ];
  };
}
