{ config, lib, pkgs, ... }:

# OpenWRT setup for custom LAN domain names:
# uci add_list dhcp.@dnsmasq[0].rebind_domain='lan'
# uci add_list dhcp.@dnsmasq[0].address='/example.lan/192.168.1.3'
# uci commit dhcp
# service dnsmasq restart

let
  services = {
    pub    = { host = "127.0.0.1"; port = 9091; };
    stream = { host = "127.0.0.1"; port = 8080; };
    weight = { host = "127.0.0.1"; port = 9090; };
  };

  mkVirtualHost = name: svc: {
    name = "http://${name}.lan";
    value = {
      extraConfig = ''
        reverse_proxy ${svc.host}:${toString svc.port}
      '';
    };
  };
in
{
  services.caddy = {
    enable = true;
    virtualHosts = (lib.mapAttrs' mkVirtualHost services) // {
      "http://192.168.1.3" = {
        extraConfig = ''
          reverse_proxy 127.0.0.1:8080
        '';
      };
    };
  };

  networking.firewall.allowedTCPPorts = [ 80 ];
}