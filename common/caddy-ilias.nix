{ config, lib, pkgs, vars, ... }:

# OpenWRT setup for custom *.home. domain names:
# uci add_list dhcp.@dnsmasq[0].rebind_domain='home.minskio.co.uk'
# uci add_list dhcp.@dnsmasq[0].address='/home.minskio.co.uk/192.168.1.3'
# uci commit dhcp
# service dnsmasq restart

let
  services = {
    drink =  { host = "127.0.0.1"; port = 9092; };
    pub    = { host = "127.0.0.1"; port = 9091; };
    stream = { host = "127.0.0.1"; port = 8080; };
    weight = { host = "127.0.0.1"; port = 9090; };
  };

  mkVirtualHost = name: svc: {
    name = "${name}.home.${vars.user.domain}";
    value = {
      extraConfig = ''
        tls {
          dns cloudflare ${vars.secrets.cloudflare}
        }
        reverse_proxy ${svc.host}:${toString svc.port}
      '';
    };
  };
in
{
  services.caddy = {
    enable = true;
    package = pkgs.caddy.withPlugins {
      plugins = [ "github.com/caddy-dns/cloudflare@v0.2.4" ];
      hash = "sha256-7GoH8YLCoPmPExQxoga2FHB58zQDoZVf1BBwkVi0SsQ=";
    };
    virtualHosts = (lib.mapAttrs' mkVirtualHost services) // {
      # Handle http://192.168.1.3:80/ fallback to Stromboli
      "http://192.168.1.3" = { extraConfig = "reverse_proxy 127.0.0.1:8080"; };
    };
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];
}