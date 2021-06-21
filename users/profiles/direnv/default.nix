{ config, lib, ... }:

with lib;

let
  # For persistence
  inherit (config.home) homeDirectory username;
  startWithHome = xdgDir:
    if (builtins.substring 0 5 xdgDir) == "$HOME" then true else false;
  relToHome = xdgDir:
    if (startWithHome xdgDir) then
      (builtins.substring 6 (builtins.stringLength xdgDir) xdgDir)
    else
      (builtins.substring (builtins.stringLength homeDirectory)
        (builtins.stringLength xdgDir) xdgDir);
  data = if config.xdg.enable then
    (relToHome config.xdg.dataHome)
  else
    ".local/share";
in {
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
  home.persistence."/persist/${homeDirectory}".directories =
    mkIf (config.home.persistence."/persist/${homeDirectory}".allowOther)
    [ "${data}/direnv" ];
}
