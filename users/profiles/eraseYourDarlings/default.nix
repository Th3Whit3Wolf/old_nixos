{ config, lib, pkgs, ... }:

with lib;

let
  inherit (config.home) homeDirectory username;

  npg = config.home.nix-polyglot;
  xdg = config.xdg;
  zsh = config.programs.ZSH;

  startWithHome = xdgDir:
    if (builtins.substring 0 5 xdgDir) == "$HOME" then true else false;
  relToHome = xdgDir:
    if (startWithHome xdgDir) then
      (builtins.substring 6 (builtins.stringLength xdgDir) xdgDir)
    else
      (builtins.substring (builtins.stringLength homeDirectory)
        (builtins.stringLength xdgDir)
        xdgDir);

  conf = if xdg.enable then (relToHome xdg.configHome) else ".config";
  cache = if xdg.enable then (relToHome xdg.cacheHome) else ".cache";
  data = if xdg.enable then (relToHome xdg.dataHome) else ".local/share";
  desktop =
    if xdg.userDirs.enable then (relToHome xdg.userDirs.desktop) else "Desktop";
  documents =
    if xdg.userDirs.enable then
      (relToHome xdg.userDirs.documents)
    else
      "Documents";
  download =
    if xdg.userDirs.enable then
      (relToHome xdg.userDirs.download)
    else
      "Downloads";
  music =
    if xdg.userDirs.enable then (relToHome xdg.userDirs.music) else "Music";
  pictures =
    if xdg.userDirs.enable then
      (relToHome xdg.userDirs.pictures)
    else
      "Pictures";
  publicShare =
    if xdg.userDirs.enable then
      (relToHome xdg.userDirs.publicShare)
    else
      "Public";
  templates =
    if xdg.userDirs.enable then
      (relToHome xdg.userDirs.templates)
    else
      "Templates";
  videos =
    if xdg.userDirs.enable then (relToHome xdg.userDirs.videos) else "Videos";
  extraUserDirs =
    if xdg.userDirs.enable then
      (attrsets.mapAttrsToList (name: value: relToHome "${value}")
        xdg.userDirs.extraConfig)
    else
      [ ];

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
      "${cache}/fontconfig"
      "${cache}/gstreamer-1.0"
      "${cache}/lollypop"
      "${conf}/pipewire/media-session.d"
      ".gnupg"
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
      "${music}"
      "${pictures}"
      "${publicShare}"
      "${templates}"
      "${videos}"
      ".ssh"

      # Vscode
      (optionalString (vscodePname != null) "${conf}/${vscodeConfigDir}")
      (optionalString (vscodePname != null) "${cache}/mesa_shader_cache")
      (optionalString (vscodePname != null) ".pki")
      (optionalString (vscodePname != null) "${vscodeExtensionDir}")
    ] ++ extraUserDirs;
  };
}
