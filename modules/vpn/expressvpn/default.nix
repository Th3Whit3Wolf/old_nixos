{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.vpn.expressvpn;

  remotes = {
    americas_argentina = "argentina-ca-version-2.expressnetw.com 1195";
    americas_brazil-2 = "brazil-2-ca-version-2.expressnetw.com 1195";
    americas_brazil = "brazil-ca-version-2.expressnetw.com 1195";
    americas_canada-montreal = "canada-montreal-ca-version-2.expressnetw.com 1195";
    americas_canada-toronto-2 = "canada-toronto-2-ca-version-2.expressnetw.com 1195";
    americas_canada-toronto = "canada-toronto-ca-version-2.expressnetw.com 1195";
    americas_canada-vancouver = "canada-vancouver-ca-version-2.expressnetw.com 1195";
    americas_chile = "chile-ca-version-2.expressnetw.com 1195";
    americas_colombia = "colombia-ca-version-2.expressnetw.com 1195";
    americas_costa-rica = "costarica-ca-version-2.expressnetw.com 1195";
    americas_ecuador = "ecuador-ca-version-2.expressnetw.com 1195";
    americas_guatemala = "guatemala-ca-version-2.expressnetw.com 1195";
    americas_mexico = "mexico-ca-version-2.expressnetw.com 1195";
    americas_panama = "panama-ca-version-2.expressnetw.com 1195";
    americas_peru = "peru-ca-version-2.expressnetw.com 1195";
    americas_usa-atlanta = "usa-atlanta-ca-version-2.expressnetw.com 1195";
    americas_usa-boston = "usa-boston-ca-version-2.expressnetw.com 1195";
    americas_usa-chicago = "usa-chicago-ca-version-2.expressnetw.com 1195";
    americas_usa-dallas-2 = "usa-dallas-2-ca-version-2.expressnetw.com 1195";
    americas_usa-dallas = "usa-dallas-ca-version-2.expressnetw.com 1195";
    americas_usa-denver = "usa-denver-ca-version-2.expressnetw.com 1195";
    americas_usa-kansascity = "usa-kansascity-ca-version-2.expressnetw.com 1195";
    americas_usa-losangeles-1 = "usa-losangeles-1-ca-version-2.expressnetw.com 1195";
    americas_usa-losangeles-2 = "usa-losangeles-2-ca-version-2.expressnetw.com 1195";
    americas_usa-losangeles-3 = "usa-losangeles-3-ca-version-2.expressnetw.com 1195";
    americas_usa-losangeles = "usa-losangeles-ca-version-2.expressnetw.com 1195";
    americas_usa-miami-2 = "usa-miami-2-ca-version-2.expressnetw.com 1195";
    americas_usa-miami = "usa-miami-ca-version-2.expressnetw.com 1195";
    americas_usa-minneapolis = "usa-minneapolis-ca-version-2.expressnetw.com 1195";
    americas_usa-newjersey-1 = "usa-newjersey-1-ca-version-2.expressnetw.com 1195";
    americas_usa-newjersey-3 = "usa-newjersey-3-ca-version-2.expressnetw.com 1195";
    americas_usa-newyork-2 = "us-new-york-2-ca-version-2.expressnetw.com 1195";
    americas_usa-newyork = "usa-newyork-ca-version-2.expressnetw.com 1195";
    americas_usa-phoenix = "usa-phoenix-ca-version-2.expressnetw.com 1195";
    americas_usa-saltlakecity = "usa-saltlakecity-ca-version-2.expressnetw.com 1195";
    americas_usa-sanfrancisco = "usa-sanfrancisco-ca-version-2.expressnetw.com 1195";
    americas_usa-sanjose = "usa-sanjose-ca-version-2.expressnetw.com 1195";
    americas_usa-seattle = "usa-seattle-ca-version-2.expressnetw.com 1195";
    americas_usa-tampa-1 = "usa-tampa-1-ca-version-2.expressnetw.com 1195";
    americas_usa-virginia = "usa-virginia-ca-version-2.expressnetw.com 1195";
    americas_usa-washingtondc-2 = "usa-washingtondc-2-ca-version-2.expressnetw.com 1195";
    americas_usa-washingtondc = "usa-washingtondc-ca-version-2.expressnetw.com 1195";
    americas_venezuela = "venezuela-ca-version-2.expressnetw.com 1195";
    asia_pacific_australia-brisbane = "australia-brisbane-ca-version-2.expressnetw.com 1195";
    asia_pacific_australia-melbourne = "australia-melbourne-ca-version-2.expressnetw.com 1195";
    asia_pacific_australia-perth = "australia-perth-ca-version-2.expressnetw.com 1195";
    asia_pacific_australia-sydney-2 = "australia-sydney-2-ca-version-2.expressnetw.com 1195";
    asia_pacific_australia-sydney = "australia-sydney-ca-version-2.expressnetw.com 1195";
    asia_pacific_bangladesh = "bangladesh-ca-version-2.expressnetw.com 1195";
    asia_pacific_bhutan = "bhutan-ca-version-2.expressnetw.com 1195";
    asia_pacific_brunei = "brunei-ca-version-2.expressnetw.com 1195";
    asia_pacific_cambodia = "cambodia-ca-version-2.expressnetw.com 1195";
    asia_pacific_hongkong-1 = "hongkong-1-ca-version-2.expressnetw.com 1195";
    asia_pacific_hongkong-2 = "hongkong-2-ca-version-2.expressnetw.com 1195";
    asia_pacific_hongkong-4 = "hongkong4-ca-version-2.expressnetw.com 1195";
    asia_pacific_india-chennai = "india-chennai-ca-version-2.expressnetw.com 1195";
    asia_pacific_india-mumbai-1 = "india-mumbai-1-ca-version-2.expressnetw.com 1195";
    asia_pacific_indonesia = "indonesia-ca-version-2.expressnetw.com 1195";
    asia_pacific_japan-tokyo-1 = "japan-tokyo-1-ca-version-2.expressnetw.com 1195";
    asia_pacific_japan-tokyo-2 = "japan-tokyo-2-ca-version-2.expressnetw.com 1195";
    asia_pacific_kazakhstan = "kazakhstan-ca-version-2.expressnetw.com 1195";
    asia_pacific_kyrgyzstan = "kyrgyzstan-ca-version-2.expressnetw.com 1195";
    asia_pacific_laos = "laos-ca-version-2.expressnetw.com 1195";
    asia_pacific_macau = "macau-ca-version-2.expressnetw.com 1195";
    asia_pacific_malaysia = "malaysia-ca-version-2.expressnetw.com 1195";
    asia_pacific_mongolia = "mongolia-ca-version-2.expressnetw.com 1195";
    asia_pacific_myanmar = "myanmar-ca-version-2.expressnetw.com 1195";
    asia_pacific_nepal = "nepal-ca-version-2.expressnetw.com 1195";
    asia_pacific_newzealand = "newzealand-ca-version-2.expressnetw.com 1195";
    asia_pacific_philippines-viasingapore = "ph-via-sing-ca-version-2.expressnetw.com 1195";
    asia_pacific_singapore-cbd = "singapore-cbd-ca-version-2.expressnetw.com 1195";
    asia_pacific_singapore-jurong = "singapore-jurong-ca-version-2.expressnetw.com 1195";
    asia_pacific_sri-lanka = "srilanka-ca-version-2.expressnetw.com 1195";
    asia_pacific_taiwan-3 = "taiwan-3-ca-version-2.expressnetw.com 1195";
    asia_pacific_thailand = "thailand-ca-version-2.expressnetw.com 1195";
    asia_pacific_vietnam = "vietnam-ca-version-2.expressnetw.com 1195";
    europe_albania = "albania-ca-version-2.expressnetw.com 1195";
    europe_andorra = "andorra-ca-version-2.expressnetw.com 1195";
    europe_armenia = "armenia-ca-version-2.expressnetw.com 1195";
    europe_austria = "austria-ca-version-2.expressnetw.com 1195";
    europe_belarus = "belarus-ca-version-2.expressnetw.com 1195";
    europe_belgium = "belgium-ca-version-2.expressnetw.com 1195";
    europe_bosnia-and-herzegovina = "bosniaandherzegovina-ca-version-2.expressnetw.com 1195";
    europe_bulgaria = "bulgaria-ca-version-2.expressnetw.com 1195";
    europe_croatia = "croatia-ca-version-2.expressnetw.com 1195";
    europe_cyprus = "cyprus-ca-version-2.expressnetw.com 1195";
    europe_czechrepublic = "czechrepublic-ca-version-2.expressnetw.com 1195";
    europe_denmark = "denmark-ca-version-2.expressnetw.com 1195";
    europe_estonia = "estonia-ca-version-2.expressnetw.com 1195";
    europe_europe_sweden-2 = "sweden-2-ca-version-2.expressnetw.com 1195";
    europe_europe_sweden = "sweden-ca-version-2.expressnetw.com 1195";
    europe_finland = "finland-ca-version-2.expressnetw.com 1195";
    europe_france-paris-1 = "france-paris-1-ca-version-2.expressnetw.com 1195";
    europe_france-paris-2 = "france-paris-2-ca-version-2.expressnetw.com 1195";
    europe_france-strasbourg = "france-strasbourg-ca-version-2.expressnetw.com 1195";
    europe_georgia = "georgia-ca-version-2.expressnetw.com 1195";
    europe_germany-darmstadt = "germany-darmstadt-ca-version-2.expressnetw.com 1195";
    europe_germany-frankfurt-1 = "germany-frankfurt-1-ca-version-2.expressnetw.com 1195";
    europe_germany-frankfurt-2 = "germany-frankfurt-2-ca-version-2.expressnetw.com 1195";
    europe_germany-nuremberg = "germany-nuremberg-ca-version-2.expressnetw.com 1195";
    europe_greece = "greece-ca-version-2.expressnetw.com 1195";
    europe_hungary = "hungary-ca-version-2.expressnetw.com 1195";
    europe_iceland = "iceland-ca-version-2.expressnetw.com 1195";
    europe_ireland = "ireland-ca-version-2.expressnetw.com 1195";
    europe_isleofman = "isleofman-ca-version-2.expressnetw.com 1195";
    europe_italy-cosenza = "italy-cosenza-ca-version-2.expressnetw.com 1195";
    europe_italy-milan = "italy-milan-ca-version-2.expressnetw.com 1195";
    europe_jersey = "jersey-ca-version-2.expressnetw.com 1195";
    europe_latvia = "latvia-ca-version-2.expressnetw.com 1195";
    europe_liechtenstein = "liechtenstein-ca-version-2.expressnetw.com 1195";
    europe_lithuania = "lithuania-ca-version-2.expressnetw.com 1195";
    europe_luxembourg = "luxembourg-ca-version-2.expressnetw.com 1195";
    europe_macedonia = "macedonia-ca-version-2.expressnetw.com 1195";
    europe_malta = "malta-ca-version-2.expressnetw.com 1195";
    europe_moldova = "moldova-ca-version-2.expressnetw.com 1195";
    europe_monaco = "monaco-ca-version-2.expressnetw.com 1195";
    europe_montenegro = "montenegro-ca-version-2.expressnetw.com 1195";
    europe_netherlands-amsterdam = "netherlands-amsterdam-ca-version-2.expressnetw.com 1195";
    europe_netherlands-rotterdam = "netherlands-rotterdam-ca-version-2.expressnetw.com 1195";
    europe_netherlands-thehague = "netherlands-thehague-ca-version-2.expressnetw.com 1195";
    europe_norway = "norway-ca-version-2.expressnetw.com 1195";
    europe_pakistan = "pakistan-ca-version-2.expressnetw.com 1195";
    europe_poland = "poland-ca-version-2.expressnetw.com 1195";
    europe_portugal = "portugal-ca-version-2.expressnetw.com 1195";
    europe_romania = "romania-ca-version-2.expressnetw.com 1195";
    europe_russia = "russia-ca-version-2.expressnetw.com 1195";
    europe_serbia = "serbia-ca-version-2.expressnetw.com 1195";
    europe_slovakia = "slovakia-ca-version-2.expressnetw.com 1195";
    europe_slovenia = "slovenia-ca-version-2.expressnetw.com 1195";
    europe_southkorea-2 = "southkorea2-ca-version-2.expressnetw.com 1195";
    europe_southkorea = "southkorea-ca-version-2.expressnetw.com 1195";
    europe_spain-barcelona = "spain-barcelona-ca-version-2.expressnetw.com 1195";
    europe_spain-madrid = "spain-ca-version-2.expressnetw.com 1195";
    europe_switzerland-2 = "switzerland-2-ca-version-2.expressnetw.com 1195";
    europe_switzerland = "switzerland-ca-version-2.expressnetw.com 1195";
    europe_turkey = "turkey-ca-version-2.expressnetw.com 1195";
    europe_uk-berkshire-2 = "uk-berkshire-2-ca-version-2.expressnetw.com 1195";
    europe_uk-berkshire = "uk-berkshire-ca-version-2.expressnetw.com 1195";
    europe_uk-docklands = "uk-docklands-ca-version-2.expressnetw.com 1195";
    europe_uk-eastlondon = "uk-east-london-ca-version-2.expressnetw.com 1195";
    europe_uk-kent = "uk-kent-ca-version-2.expressnetw.com 1195";
    europe_uk-london = "uk-london-ca-version-2.expressnetw.com 1195";
    europe_ukraine = "ukraine-ca-version-2.expressnetw.com 1195";
    europe_uruguay = "uruguay-ca-version-2.expressnetw.com 1195";
    middle_east_and_africa_algeria = "algeria-ca-version-2.expressnetw.com 1195";
    middle_east_and_africa_egypt = "egypt-ca-version-2.expressnetw.com 1195";
    middle_east_and_africa_israel = "israel-ca-version-2.expressnetw.com 1195";
    middle_east_and_africa_kenya = "kenya-ca-version-2.expressnetw.com 1195";
    middle_east_and_africa_southafrica = "southafrica-ca-version-2.expressnetw.com 1195";
  };

  remoteConfig = name: remote: pkgs.lib.nameValuePair ("client-expressvpn-" + name) (generateOpenVPNConfig remote);

  generateOpenVPNConfig = remote: {
    autoStart = false;
    updateResolvConf = true;

    config = builtins.readFile (pkgs.substituteAll {
      src = ./config.ovpn;

      inherit remote;

      # Go to https://www.expressvpn.com/setup#manual
      # 1) copy the username and password given to you in step 1 and write
      #    them, each on a new line, in the auth.txt file below.
      # 2) Download the ZIP file from step 4 and make them available to cert,
      #    key, tls-auth and ca below.
      inherit (cfg) auth_user_pass ca client_cert client_key tls_auth;
    });
  };

  ovpnConfigFile = pkgs.writeText "openvpn-config-${name}" ''
    errors-to-stderr
    ${optionalString (cfg.up != "" || cfg.down != "" || cfg.updateResolvConf) "script-security 2"}
    ${cfg.config}
    ${optionalString (cfg.up != "" || cfg.updateResolvConf)
        "up ${pkgs.writeScript "openvpn-${name}-up" upScript}"}
    ${optionalString (cfg.down != "" || cfg.updateResolvConf)
        "down ${pkgs.writeScript "openvpn-${name}-down" downScript}"}
    ${optionalString (cfg.authUserPass != null)
        "auth-user-pass ${pkgs.writeText "openvpn-credentials-${name}" ''
          ${cfg.authUserPass.username}
          ${cfg.authUserPass.password}
        ''}"}
  '';



in
{
  options.vpn.expressvpn = {
    enable = mkEnableOption "Enable ExpressionVPN client configuration";

    # TODO(low): options must be camelcase

    auth_user_pass = mkOption {
      type = types.path;
      defaultText = ''
        Contents to the file containing the username and password.
      '';
    };

    ca = mkOption {
      type = types.path;
      defaultText = ''
        Contents to the certificate authority.
      '';
    };

    client_cert = mkOption {
      type = types.path;
      defaultText = ''
        Contents to the certificate
      '';
    };

    client_key = mkOption {
      type = types.path;
      defaultText = ''
        Contents to the private key
      '';
    };

    tls_auth = mkOption {
      type = types.path;
      defaultText = ''
        Contents to the private TLS auth key
      '';
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = builtins.pathExists cfg.auth_user_pass;
        message = "auth_user_pass: No such file or directory: ${builtins.toString cfg.auth_user_pass}";
      }

      {
        assertion = builtins.pathExists cfg.ca;
        message = "ca: No such file or directory: ${builtins.toString cfg.ca}";
      }

      {
        assertion = builtins.pathExists cfg.client_cert;
        message = "client_cert: No such file or directory: ${builtins.toString cfg.client_cert}";
      }

      {
        assertion = builtins.pathExists cfg.client_key;
        message = "client_key: No such file or directory: ${builtins.toString cfg.client_key}";
      }

      {
        assertion = builtins.pathExists cfg.tls_auth;
        message = "tls_auth: No such file or directory: ${builtins.toString cfg.tls_auth}";
      }
    ];

    services.openvpn.servers = pkgs.lib.mapAttrs' remoteConfig remotes;
  };
}
