{ lib, modulesPath, pkgs, suites, hardware, profiles, ... }:
let
  inherit (builtins) toFile readFile;
  inherit (lib) fileContents mkForce;

  name = "Just the doctor";
in
{
  users.users.doc = {
    uid = 1000;
    description = name;
    isNormalUser = true;
    initialHashedPassword = fileContents ../../../secrets/doc;
    extraGroups = [ "wheel" "input" "networkmanager" "libvirtd" ];
  };

}
