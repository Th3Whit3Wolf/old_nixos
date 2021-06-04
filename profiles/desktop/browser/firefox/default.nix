{ config, lib, pkgs, ... }:

{
  config = {
    services.psd.enable = true;
    environment.systemPackages = [ pkgs.fuse-overlayfs pkgs.profile-sync-daemon ];
  };
}
