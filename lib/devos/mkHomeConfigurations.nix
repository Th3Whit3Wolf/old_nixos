{ lib }:

nixosConfigurations:

with lib;
let
  mkHomes = host: config:
    mapAttrs' (user: v: nameValuePair "${user}@${host}" v.home)
      config.config.system.build.homes;

  hmConfigs = mapAttrs mkHomes nixosConfigurations;

in
foldl recursiveUpdate { } (attrValues hmConfigs)
