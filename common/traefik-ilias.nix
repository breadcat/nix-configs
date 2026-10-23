{ config, lib, pkgs, vars, ... }:

# OpenWRT setup for custom *.home. domain names:
# uci add_list dhcp.@dnsmasq[0].rebind_domain='home.minskio.co.uk'
# uci add_list dhcp.@dnsmasq[0].address='/home.minskio.co.uk/192.168.1.3'
# uci commit dhcp
# service dnsmasq restart

let
  services = {
    drink  = { host = "127.0.0.1"; port = 9092; };
    pub    = { host = "127.0.0.1"; port = 9091; };
    stream = { host = "127.0.0.1"; port = 8080; };
    weight = { host = "127.0.0.1"; port = 9090; };
  };

  domain = "home.${vars.user.domain}";

  mkRouter = name: _: {
    name = name;
    value = {
      rule = "Host(`${name}.${domain}`)";
      entryPoints = [ "websecure" ];
      service = name;
      tls.certResolver = "cloudflare";
    };
  };

  mkService = name: svc: {
    name = name;
    value.loadBalancer.servers = [{ url = "http://${svc.host}:${toString svc.port}"; }];
  };
in
{
  services.traefik = {
    enable = true;

    staticConfigOptions = {
      # log.level = "DEBUG";
      entryPoints = {
        web.address = ":80";
        websecure.address = ":443";
      };

      certificatesResolvers.cloudflare.acme = {
        email = vars.user.email;
        storage = "/var/lib/traefik/acme.json";
        dnsChallenge = {
          provider = "cloudflare";
          # Query public DNS, since your dnsmasq override hides the real TXT records
          resolvers = [ "1.1.1.1:53" "8.8.8.8:53" ];
        };
      };
    };

    dynamicConfigOptions.http = {
      routers = (lib.mapAttrs' mkRouter services) // {
        # http -> https for the named hosts
        redirect = {
          rule = "HostRegexp(`^.+\\.home\\.${lib.replaceStrings [ "." ] [ "\\." ] vars.user.domain}$`)";
          entryPoints = [ "web" ];
          middlewares = [ "https-redirect" ];
          service = "noop@internal";
        };
        # http://192.168.1.3 fallback to Stromboli
        fallback = {
          rule = "Host(`192.168.1.3`)";
          entryPoints = [ "web" ];
          service = "stream";
        };
      };

      middlewares.https-redirect.redirectScheme.scheme = "https";
      services = lib.mapAttrs' mkService services;
    };
  };

  systemd.services.traefik.environment = { CF_DNS_API_TOKEN = vars.secrets.cloudflare; };

  networking.firewall.allowedTCPPorts = [ 80 443 ];
}
