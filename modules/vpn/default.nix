{ config, lib, pkgs, ... }:
let
  killswitch-enabled = (pkgs.writeScriptBin "killswitch-enabled" ''
    #! ${pkgs.runtimeShell}
    export PATH=${pkgs.iptables}/bin
    iptables -C OUTPUT -j nixos-vpn-killswitch &> /dev/null
  '');
  killswitch-up = (pkgs.writeScriptBin "killswitch-up" ''
    #! ${pkgs.runtimeShell}
    export PATH=${pkgs.iptables}/bin:${killswitch-enabled}/bin
    if killswitch-enabled; then
      echo "Killswitch already enabled";
    else
      iptables -A OUTPUT -j nixos-vpn-killswitch
    fi
  '');
  killswitch-down = (pkgs.writeScriptBin "killswitch-down" ''
    #! ${pkgs.runtimeShell}
    export PATH=${pkgs.iptables}/bin:${killswitch-enabled}/bin
    if killswitch-enabled; then
      iptables -D OUTPUT -j nixos-vpn-killswitch
    else
      echo "Killswitch already disabled";
    fi
  '');
  killswitch-toggle = (pkgs.writeScriptBin "killswitch-toggle" ''
    #! ${pkgs.runtimeShell}
    export PATH=${pkgs.iptables}/bin:${killswitch-enabled}/bin:${killswitch-up}/bin:${killswitch-down}/bin
    if killswitch-enabled; then
      killswitch-down
    else
      killswitch-up
    fi
  '');


  toImport = name: value: ./. + ("/" + name);
  imports = lib.mapAttrsToList toImport
    (lib.filterAttrs filterCaches (builtins.readDir ./.));
  filterCaches = key: value: value == "directory";

  vpns = [
    "expressvpn"
  ];

  vpnPort = vpn: {
    "expressvpn" = "1195";
  }.${vpn};

  enabled = builtins.any (x: builtins.isBool x && x == true) (lib.forEach vpns (x: config.vpn.${x}.enable));
  allowVPNTraffic = builtins.concatStringsSep "\n" (lib.forEach vpns (x: "iptables -A nixos-vpn-killswitch -p udp -m udp --dport ${vpnPort x} -j ACCEPT"));
in
{
  inherit imports;

  config = lib.mkIf enabled {


    /*
      # 2. Write a script for connecting to the VPN which punches a hole in the firewall
      #    for the VPN server (and tun0?)
      # 3. Write a script which explicitly opens firewall for outbound traffic without
      #    passing through tun0.
      # 4. Display warning in waybar that outbound traffic is permitted unsecured

      # VPN Killswitch
      # Require VPN to access the internet
      networking.firewall.extraCommands = ''
      # Flush old firewall rules
      iptables -D OUTPUT -j nixos-vpn-killswitch 2> /dev/null || true
      iptables -F "nixos-vpn-killswitch" 2> /dev/null || true
      iptables -X "nixos-vpn-killswitch" 2> /dev/null || true
      # Create chain
      iptables -N nixos-vpn-killswitch
      # Allow traffic on localhost
      iptables -A nixos-vpn-killswitch -o lo -j ACCEPT
      # Allow LAN traffic
      iptables -A nixos-vpn-killswitch -d "192.168.0.0/16" -j ACCEPT
      iptables -A nixos-vpn-killswitch -d "192.168.0.0/24" -j ACCEPT

      # Allow outgoing traffic to local dhcp servers
      # This is a backup if LAN doesn't match
      # iptables -A nixos-vpn-killswitch -d 255.255.255.255 -j ACCEPT
      # Allow Ping (I want to be able to check if internet works when VPN is down)
      iptables -A nixos-vpn-killswitch -p icmp --icmp-type 8 -j ACCEPT
      # Allow connecting to vpn servers over UDP
      ${allowVPNTraffic}
      # Allow connections tunneled over VPN
      iptables -A nixos-vpn-killswitch -o tun0 -j ACCEPT
      # Allow related/established traffic
      # iptables -A nixos-vpn-killswitch -m state -state RELATED,ESTABLISHED -j ACCEPT
      # Disallow outgoing traffic by default
      iptables -A nixos-vpn-killswitch -j DROP
      # Enable killswitch
      # iptables -A OUTPUT -j nixos-vpn-killswitch
      # Disable ipv6
      # ip6tables -P INPUT DROP
      # ip6tables -P OUTPUT DROP
      # ip6tables -P FORWARD DROP
      '';

      # There may be a moment of leakage when we reload the firewall
      # Ideally we'd fix this by adding commands below
      # networking.firewall.extraStopCommands = ''
      # '';

      # networking.firewall.extraStopCommands = ''
      # '';

      # Scripts to control the killswitch
      environment.systemPackages =
      [ killswitch-up killswitch-down killswitch-enabled killswitch-toggle ];

      networking.networkmanager.dispatcherScripts = [
      {
      source = pkgs.writeScript "03vpnkillswitch" ''
      interface=$1 status=$2
      # Automatically turn on killswitch when VPN connects
      # Require manual disengage on disconnect
      case $status in
      vpn-up)
      ${killswitch-up}/bin/killswitch-up
      ;;
      esac
      exit 0
      '';
      type = "basic";
      }
      ];

      # Works but something is slow.
      # I think DNS is not being routed through the VPN.
      # May be better to use networkmanager-openvpn anyway.
      # services.openvpn.servers = {
      #   nordvpn-us = {
      #     autoStart = false;
      #     config = ''
      #       config /etc/nixos/ovpn/ovpn_udp/us4594.nordvpn.com.udp.ovpn
      #       auth-user-pass /etc/nixos/nordvpn_auth.txt
      #     '';
      #     updateResolvConf = true;
      #   };
      #   nordvpn-p2p = {
      #     autoStart = false;
      #     config = ''
      #       config /etc/nixos/ovpn/ovpn_udp/us3395.nordvpn.com.udp.ovpn
      #       auth-user-pass /etc/nixos/nordvpn_auth.txt
      #     '';
      #   };
      # };

      # networking.nftables.enable = true;
      # networking.nftables.ruleset = ''
      #   table ip filter {
      #     # Block all incomming connections traffic except SSH and "ping".
      #     chain input {
      #       type filter hook input priority 0;

      #       # accept any localhost traffic
      #       iifname lo accept

      #       # accept traffic originated from us
      #       ct state {established, related} accept

      #       # TODO: ICMP
      #       # routers may also want: mld-listener-query, nd-router-solicit
      #       # ip6 nexthdr icmpv6 icmpv6 type { destination-unreachable, packet-too-big, time-exceeded, parameter-problem, nd-router-advert, nd-neighbor-solicit, nd-neighbor-advert } accept
      #       # ip protocol icmp icmp type { destination-unreachable, router-advertisement, time-exceeded, parameter-problem } accept

      #       # allow "ping"
      #       # ip6 nexthdr icmpv6 icmpv6 type echo-request accept
      #       # ip protocol icmp icmp type echo-request accept

      #       # count and drop any other traffic
      #       counter drop
      #     }

      #     # Allow all outgoing connections.
      #     chain output {
      #       type filter hook output priority 0;

      #       # accept any localhost traffic
      #       iifname lo accept

      #       # accept LAN traffic
      #       daddr 192.168.0.0/24 accept

      #       # allow vpn connections
      #       udp dport 1194 accept

      #       # allow traffic tunneled over vpn
      #       iifname tun0 accept

      #       # drop any other traffic
      #       drop
      #     }

      #     chain forward {
      #       type filter hook forward priority 0;

      #       # I'm not a router
      #       drop
      #     }
      #   }
      # '';
    */
  };
}
