{
  imports = [
    ./networkManager.nix
  ];

  config.systemd.services.systemd-logind.serviceConfig = {
    SupplementaryGroups = "proc";
  };
}
# https://github.com/krathalan/systemd-sandboxing
