let
  # set ssh public keys here for your system and user
  tardis =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJkLZ0XlA9Q/K6w/8WZX3imJzJxHgOuTxNmNsVlSstBA the.white.wolf.is.1337@gmail.com";
  allKeys = [ tardis ];

  allKeysSecrets = builtins.listToAttrs (map
    (name: {
      inherit name;
      value = { publicKeys = allKeys; };
    }) [
    "doc.age"
  ]);
in
allKeysSecrets
