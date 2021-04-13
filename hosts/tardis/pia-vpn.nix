# NixOS Module for Private Internet Access (VPN) support in NetworkManager.

{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.networking.networkmanager.pia-vpn;

  piaCertificateFile = pkgs.fetchurl {
    url = "https://www.privateinternetaccess.com/openvpn/ca.rsa.4096.crt";
    sha256 = "1av6dilvm696h7pb5xn91ibw0mrziqsnwk51y8a7da9y8g8v3s9j";
  };

  # id: human facing name of the connection (visible in NetworkManager)
  # uuid: any UUID in the form produced by uuid(1) (or perhaps _any_ string?)
  # remote: hostname of PIAs server (e.g. "uk-london.privateinternetaccess.com")
  #
  # See https://www.privateinternetaccess.com/installer/pia-nm.sh for available
  # options.
  template = { id, uuid, remote }: ''
    [connection]
    id=${id}
    uuid=${uuid}
    type=vpn
    autoconnect=false
    [vpn]
    service-type=org.freedesktop.NetworkManager.openvpn
    username=${if cfg.username != "" then cfg.username else "@USERNAME@"}
    comp-lzo=yes
    remote=${remote}
    cipher=AES-256-CBC
    auth=SHA256
    connection-type=password
    password-flags=${
      if cfg.password != "" || cfg.passwordFile != null then "0" else "1"
    }
    port=1197
    proto-tcp=no
    ca=${piaCertificateFile}
    [ipv4]
    method=auto
    ${lib.optionalString (cfg.password != "" || cfg.passwordFile != null) ''
      [vpn-secrets]
      password=${if cfg.password != "" then cfg.password else "@PASSWORD@"}
    ''}
  '';

  toSubdomain = server: lib.removeSuffix ".privateinternetaccess.com" server;

  # 
  allServers = [
    {
      id = "PIA - Mexico";
      uuid = "4b1ccfa9-3457-5ea4-824a-0d86d78f40e9";
      remote = "mexico.privateinternetaccess.com";
    }
    {
      id = "PIA - CA Toronto";
      uuid = "80a635f8-df93-56f2-a570-65899ba599bb";
      remote = "ca-toronto.privateinternetaccess.com";
    }
    {
      id = "PIA - CA Montreal";
      uuid = "94380df4-dd68-5446-8ce2-c0a7e6d60c49";
      remote = "ca.privateinternetaccess.com";
    }
    {
      id = "PIA - India";
      uuid = "48e0ff64-2a90-516c-956a-31d0c27be403";
      remote = "in.privateinternetaccess.com";
    }
    {
      id = "PIA - US Florida";
      uuid = "f7c94a50-de0e-5eab-9dd0-25b9ba02fef0";
      remote = "us-florida.privateinternetaccess.com";
    }
    {
      id = "PIA - UK Southampton";
      uuid = "2575a50f-42fe-569f-9045-42643143f922";
      remote = "uk-southampton.privateinternetaccess.com";
    }
    {
      id = "PIA - Japan";
      uuid = "632ed90a-bf6a-555f-a556-de63e62bdca7";
      remote = "japan.privateinternetaccess.com";
    }
    {
      id = "PIA - Turkey";
      uuid = "e2349345-5e54-54ca-a641-a08fc45c59b4";
      remote = "turkey.privateinternetaccess.com";
    }
    {
      id = "PIA - Netherlands";
      uuid = "d2a54487-3987-56a3-bdb7-688635876001";
      remote = "nl.privateinternetaccess.com";
    }
    {
      id = "PIA - Norway";
      uuid = "94ed319f-8dcc-5c35-abc2-d1c0df8f267a";
      remote = "no.privateinternetaccess.com";
    }
    {
      id = "PIA - AU Melbourne";
      uuid = "f8637490-de9e-5a76-94dd-6b40b6d1dbe9";
      remote = "aus-melbourne.privateinternetaccess.com";
    }
    {
      id = "PIA - New Zealand";
      uuid = "13aaa4db-f761-57d3-99de-2582f860efdb";
      remote = "nz.privateinternetaccess.com";
    }
    {
      id = "PIA - France";
      uuid = "ad239203-0b0e-5649-b8e6-57427d738eb8";
      remote = "france.privateinternetaccess.com";
    }
    {
      id = "PIA - AU Sydney";
      uuid = "1be63659-00c4-5e82-bd7e-0243af558ee3";
      remote = "aus.privateinternetaccess.com";
    }
    {
      id = "PIA - Ireland";
      uuid = "c8d2d518-57e1-5e27-948f-3fe73b0eb400";
      remote = "ireland.privateinternetaccess.com";
    }
    {
      id = "PIA - Romania";
      uuid = "4d375e8d-b950-5d95-93ea-f854e0c48f61";
      remote = "ro.privateinternetaccess.com";
    }
    {
      id = "PIA - Brazil";
      uuid = "f9db3ea9-d0ba-580d-91e0-7a21f2b6f6a9";
      remote = "brazil.privateinternetaccess.com";
    }
    {
      id = "PIA - Israel";
      uuid = "afc147bb-ae90-5922-8162-e0276ea85760";
      remote = "israel.privateinternetaccess.com";
    }
    {
      id = "PIA - US Midwest";
      uuid = "9ab0eef6-3e3a-5cd8-936b-2518e28ef9b6";
      remote = "us-midwest.privateinternetaccess.com";
    }
    {
      id = "PIA - US California";
      uuid = "37ac009c-5cc0-5cfc-a2ec-f067c7e0b212";
      remote = "us-california.privateinternetaccess.com";
    }
    {
      id = "PIA - Hong Kong";
      uuid = "708d716c-923f-55d7-bd0f-aced817bb589";
      remote = "hk.privateinternetaccess.com";
    }
    {
      id = "PIA - Germany";
      uuid = "b744d855-d4cc-52b9-aa24-9bee159c0109";
      remote = "germany.privateinternetaccess.com";
    }
    {
      id = "PIA - Finland";
      uuid = "51829104-98b9-5649-850b-37eb33e21f3a";
      remote = "fi.privateinternetaccess.com";
    }
    {
      id = "PIA - US Chicago";
      uuid = "8cf137b6-bea8-5d2b-9687-b0976b8a5341";
      remote = "us-chicago.privateinternetaccess.com";
    }
    {
      id = "PIA - US Silicon Valley";
      uuid = "7f261a73-9487-5d7f-95ee-cb798a2dc904";
      remote = "us-siliconvalley.privateinternetaccess.com";
    }
    {
      id = "PIA - US New York City";
      uuid = "9e3f0be2-87eb-5352-a321-23d22bf0d85e";
      remote = "us-newyorkcity.privateinternetaccess.com";
    }
    {
      id = "PIA - US Texas";
      uuid = "0b5cb308-1d16-56ad-830c-6253b475f4df";
      remote = "us-texas.privateinternetaccess.com";
    }
    {
      id = "PIA - Italy";
      uuid = "b25088c7-3746-5d1d-92c0-79799f5ff80c";
      remote = "italy.privateinternetaccess.com";
    }
    {
      id = "PIA - South Korea";
      uuid = "e914f6a5-3b19-58a2-bd39-bdf3ea36f343";
      remote = "kr.privateinternetaccess.com";
    }
    {
      id = "PIA - Sweden";
      uuid = "c24581b8-69a1-5fd0-9100-56f5f5010944";
      remote = "sweden.privateinternetaccess.com";
    }
    {
      id = "PIA - US West";
      uuid = "c881ad44-b2b6-51d2-b7e3-373b680554c2";
      remote = "us-west.privateinternetaccess.com";
    }
    {
      id = "PIA - US East";
      uuid = "37a27719-7ebd-500a-9a7b-4daa017bb27d";
      remote = "us-east.privateinternetaccess.com";
    }
    {
      id = "PIA - UK London";
      uuid = "1bbd385a-6d03-5661-9871-bca00b9cf66f";
      remote = "uk-london.privateinternetaccess.com";
    }
    {
      id = "PIA - Denmark";
      uuid = "5a5703fc-b960-516a-a786-9b59200ee52f";
      remote = "denmark.privateinternetaccess.com";
    }
    {
      id = "PIA - Switzerland";
      uuid = "961a068b-71a0-5440-aa43-0f63e443cf34";
      remote = "swiss.privateinternetaccess.com";
    }
    {
      id = "PIA - US Seattle";
      uuid = "be257767-864c-560a-8b30-b66c3270a312";
      remote = "us-seattle.privateinternetaccess.com";
    }
    {
      id = "PIA - Singapore";
      uuid = "a92761e1-d0b1-5630-98b5-6b5f225d364a";
      remote = "sg.privateinternetaccess.com";
    }
  ];

  filteredServers =
    builtins.filter (x: lib.elem (toSubdomain x.remote) cfg.serverList)
    allServers;

  allServerSubdomains = map (x: toSubdomain x.remote) allServers;

  serverEntryToEtcFilename = serverEntry:
    let n = toSubdomain serverEntry.remote;
    in "NetworkManager/system-connections/pia-vpn-${n}";

  serverEntryToEtcFile = serverEntry:

    {
      "${serverEntryToEtcFilename serverEntry}" = {
        text = template { inherit (serverEntry) id uuid remote; };
        # NetworkManager refuses to load world readable files
        mode = "0600";
      };
    };

  etcFiles =
    lib.fold (x: acc: lib.recursiveUpdate (serverEntryToEtcFile x) acc) { }
    filteredServers;
in {
  options.networking.networkmanager.pia-vpn = {

    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to enable Private Internet Access VPN connections in NetworkManager.
        To make NetworkManager update its UI after using this module to
        add/remove connections, you either have to run
        `sudo nmcli connection reload` or reboot.
      '';
    };

    username = mkOption {
      type = types.str;
      default = "";
      description = ''
        Your PIA username. If you don't want your username to be world readable
        in the Nix store, use the usernameFile option. The password for this
        username is either entered interactively when starting the connection
        for the first time (the password is stored in the OS keyring) or you can use
        the password or passwordFile options.
        Warning: The username is world readable in the Nix store.
      '';
    };

    usernameFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      example = "/run/keys/pia-vpn.username";
      description = ''
        Path to a file containing your PIA username. (To not leak username to
        the Nix store.) The username will be copied into the file(s)
        <literal>/etc/NetworkManager/system-connections/pia-vpn-*</literal>.
      '';
    };

    password = mkOption {
      type = types.str;
      default = "";
      description = ''
        Your PIA password (optional). If null, NetworkManager will prompt for
        the password when enabling the connection. That password will then be
        stored in the OS keyring. If non-null, the password will be stored, in
        plain text, in the file(s)
        <literal>/etc/NetworkManager/system-connections/pia-vpn-*</literal>.
        Warning: If this option is used (i.e. non-null), it stores the password
        in world readable Nix store, in addition to a file under
        /etc/NetworkManager/system-connections/. See passwordFile option as an
        alternative that doesn't leak password info to the Nix store.
      '';
    };

    passwordFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      example = "/run/keys/pia-vpn.password";
      description = ''
        Path to a file containing your PIA password (optional). If neither this
        nor the password option is defined, NetworkManager will prompt for
        the password when enabling the connection. That password will then be
        stored in the OS keyring. If non-null, the password in this file will
        be embedded (in plain text) into the file(s)
        <literal>/etc/NetworkManager/system-connections/pia-vpn-*</literal>.
        This option doesn't leak the password to the Nix store.
      '';
    };

    serverList = mkOption {
      type = types.listOf types.str;
      default = allServerSubdomains;
      description = ''
        List of PIA VPN servers that will be available for use. If you only use
        a few servers you can reduce some UI clutter by listing only those
        servers here.
      '';
    };

  };

  config = mkIf cfg.enable {

    assertions = [
      {
        assertion = cfg.username != "" || cfg.usernameFile != null;
        message =
          "Either networking.networkmanager.pia-vpn.username or ..usernameFile must be set.";
      }
      {
        assertion = (cfg.username != "") == (cfg.usernameFile == null);
        message =
          "Only one of networking.networkmanager.pia-vpn.username and ..usernameFile can be set.";
      }
      { # Password can be unset, NetworkManager will use OS keyring.
        assertion =
          if cfg.password != "" then (cfg.passwordFile == null) else true;
        message =
          "Only one of networking.networkmanager.pia-vpn.password and ..passwordFile can be set.";
      }
      {
        assertion = (lib.length cfg.serverList) > 0;
        message =
          "The option networking.networkmanager.pia-vpn.serverList is empty, no VPN connections can be made.";
      }
      {
        assertion = all (x: elem x allServerSubdomains) cfg.serverList;
        message = let
          badElements = builtins.filter (x: !(lib.elem x allServerSubdomains))
            cfg.serverList;
        in ''
          The option networking.networkmanager.pia-vpn.serverList contains one or more bad elements: ${
            builtins.toString badElements
          }
          Allowed elements: ${builtins.toString allServerSubdomains}
        '';
      }
    ];

    environment.etc = etcFiles;

    system.activationScripts.pia-nm-usernameFile =
      lib.mkIf (cfg.usernameFile != null)
      (stringAfter [ "etc" "specialfs" "var" ] ''
        if [ -f "${cfg.usernameFile}" ]; then
          ${pkgs.systemd}/bin/systemd-cat -t nixos echo "<6>loading networking.networkmanager.pia-vpn.usernameFile from ${cfg.usernameFile}"
          ${
            lib.concatMapStringsSep "\n" (f:
              ''
                ${pkgs.gnused}/bin/sed -ie "s/@USERNAME@/$(< ${cfg.usernameFile})/" ${f}'')
            (map (s: "/etc/${serverEntryToEtcFilename s}") filteredServers)
          }
        else
            msg="WARNING: networking.networkmanager.pia-vpn.usernameFile (${cfg.usernameFile}) does not exist."
            echo "$msg"
            ${pkgs.systemd}/bin/systemd-cat -t nixos echo "<4>$msg"
        fi
      '');

    system.activationScripts.pia-nm-passwordFile =
      lib.mkIf (cfg.passwordFile != null)
      (stringAfter [ "etc" "specialfs" "var" ] ''
        if [ -f "${cfg.passwordFile}" ]; then
          ${pkgs.systemd}/bin/systemd-cat -t nixos echo "<6>loading networking.networkmanager.pia-vpn.passwordFile from ${cfg.passwordFile}"
          ${
            lib.concatMapStringsSep "\n" (f:
              ''
                ${pkgs.gnused}/bin/sed -ie "s/@PASSWORD@/$(< ${cfg.passwordFile})/" ${f}'')
            (map (s: "/etc/${serverEntryToEtcFilename s}") filteredServers)
          }
        else
            msg="WARNING: networking.networkmanager.pia-vpn.passwordFile (${cfg.passwordFile}) does not exist."
            echo "$msg"
            ${pkgs.systemd}/bin/systemd-cat -t nixos echo "<4>$msg"
        fi
      '');
  };

}
