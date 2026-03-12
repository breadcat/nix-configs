{ config, lib, pkgs, ... }:

let
  services = {
    music  = { host = "127.0.0.1"; port = 4533; };
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
      "http://192.168.1.3:80" = {
        extraConfig = ''
          reverse_proxy 127.0.0.1:8080
        '';
      };
    };
  };

  networking.firewall.allowedTCPPorts = [ 80 ];
}