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

}
