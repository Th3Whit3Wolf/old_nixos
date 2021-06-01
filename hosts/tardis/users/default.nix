{ lib, ... }:
let
  inherit (builtins) toFile readFile;
  inherit (lib) fileContents mkForce;

in
{
  imports = [
    ./doc.nix
  ];

  users.users.root.initialHashedPassword = fileContents ../secrets/root;
  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;
  };

  # Immutable users due to tmpfs
  users.mutableUsers = false;
}
