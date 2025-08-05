{ pkgs, username, domain, timezone, todosecret, vpnusername, vpnpassword, ... }: {

  # Runtime
  virtualisation.docker.enable = true;
  virtualisation.docker.autoPrune.enable = true;
  users.extraUsers.${username}.extraGroups = ["docker"];

  # Create Network
  systemd.services.docker-create-proxy-network = {
    description = "Create proxy Docker network if not exists";
    after = [ "docker.service" ];
    requires = [ "docker.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.bash}/bin/bash -c '${pkgs.docker}/bin/docker network inspect proxy >/dev/null 2>&1 || ${pkgs.docker}/bin/docker network create proxy'";
      RemainAfterExit = true;
    };
  };

  # Firewall
  networking.firewall.allowedTCPPorts = [ 80 443 ];

  # Containers
  virtualisation.oci-containers = {
    backend = "docker";
    containers = {

      caddy = {
        autoStart = true;
        environment = { CADDY_INGRESS_NETWORKS = "proxy"; };
        image = "lucaslorentz/caddy-docker-proxy";
        networks = [ "proxy" ];
        ports = [ "80:80" "443:443" ];
        volumes = [ "/var/run/docker.sock:/var/run/docker.sock:rw" "/home/${username}/docker/caddy:/data" ];
        };

      echoip = {
        autoStart = true;
        cmd = [ "-H" "X-Forwarded-For" ];
        image = "mpolden/echoip";
        labels = { "caddy" = "ip.artemis.${domain}"; "caddy.reverse_proxy" = "{{upstreams 8080}}"; };
        networks = [ "proxy" ];
        };

      stagit = {
        autoStart = true;
        environment = { PGID = "100"; PUID = "1000";};
        image = "lscr.io/linuxserver/nginx";
        labels = { "caddy" = "git.artemis.${domain}"; "caddy.reverse_proxy" = "{{upstreams 80}}"; };
        networks = [ "proxy" ];
        volumes = [ "/home/${username}/docker/stagit:/config/www:ro" ];
        };

      vikunja = {
        autoStart = true;
        environment = { PGID = "100"; PUID = "1000"; VIKUNJA_SERVICE_ENABLEREGISTRATION = "false"; VIKUNJA_SERVICE_ENABLETASKCOMMENTS = "false"; VIKUNJA_SERVICE_JWTSECRET = "${todosecret}"; VIKUNJA_SERVICE_PUBLICURL = "https://todo.artemis.${domain}/"; VIKUNJA_SERVICE_TIMEZONE = "${timezone}";};
        image = "vikunja/vikunja";
        labels = { "caddy" = "todo.artemis.${domain}"; "caddy.reverse_proxy" = "{{upstreams 3456}}"; };
        networks = [ "proxy" ];
        volumes = [ "/home/${username}/docker/vikunja:/db:rw" ];
        };

    };
  };
}
