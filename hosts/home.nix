{ config, lib, ... }:

with lib; {
  networking.hosts = let
    hostConfig = {
      "192.168.1.2" = [ "ao" ];
      "192.168.1.3" = [ "kiiro" ];
      "192.168.1.10" = [ "kuro" ];
      "192.168.1.11" = [ "shiro" ];
      "192.168.1.12" = [ "midori" ];
    };
    hosts = flatten (attrValues hostConfig);
    hostName = config.networking.hostName;
  in mkIf (builtins.elem hostName hosts) hostConfig;

  ## Location config -- since Toronto is my 127.0.0.1
  time.timeZone = mkDefault "Europe/London";
  i18n.defaultLocale = mkDefault "en_US.UTF-8";
  # For redshift, mainly
  location = (if config.time.timeZone == "Europe/London" then {
    latitude = 52.4045;
    longitude = -0.5613;
  } else if config.time.timeZone == "Europe/Copenhagen" then {
    latitude = 55.88;
    longitude = 12.5;
  } else
    { });

  # So thw bitwarden CLI knows where to find my server.
  # modules.shell.bitwarden.config.server = "p.v0.io";
  environment.etc = {
    "machine-id".source = "/persist/etc/machine-id";
    "ssh/ssh_host_rsa_key".source = "/persist/etc/ssh_host_rsa_key";
    "ssh/ssh_host_rsa_key.pub".source = "/persist/etc/ssh_host_rsa_key.pub";
    "ssh/ssh_host_ed25519_key".source = "/persist/etc/ssh_host_ed25519_key";
    "ssh/ssh_host_ed25519_key.pub".source =
      "/persist/etc/ssh_host_ed25519_key.pub";
    "NetworkManager/system-connections".source =
      "/persist/etc/NetworkManager/system-connections";
  };
  systemd.tmpfiles.rules = [
    "L /var/lib/NetworkManager/secret_key - - - - /persist/var/lib/NetworkManager/secret_key"
    "L /var/lib/NetworkManager/timestamps - - - - /persist/var/lib/NetworkManager/timestamps"
  ];
}
