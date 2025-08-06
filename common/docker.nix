{ pkgs, username, domain, timezone, todosecret, htpasswd, vpnusername, vpnpassword, ... }: {

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

      baikal = {
        autoStart = true;
        dependsOn = [ "caddy" ];
        image = "ckulka/baikal:nginx";
        labels = { "caddy" = "dav.${domain}"; "caddy.reverse_proxy" = "{{upstreams 80}}"; };
        networks = [ "proxy" ];
        volumes = [ "/home/${username}/docker/baikal:/var/www/baikal/Specific" ];
        };

      caddy = {
        autoStart = true;
        environment = { CADDY_INGRESS_NETWORKS = "proxy"; };
        image = "lucaslorentz/caddy-docker-proxy";
        networks = [ "proxy" ];
        ports = [ "80:80" "443:443" ];
        volumes = [ "/var/run/docker.sock:/var/run/docker.sock" "/home/${username}/docker/caddy:/data" ];
        };

      changedetection = {
        autoStart = true;
        dependsOn = [ "caddy" ];
        environment = { PGID = "100"; PUID = "1000"; LC_ALL = "en_US.UTF-8";};
        image = "lscr.io/linuxserver/changedetection.io";
        labels = { "caddy" = "diff.${domain}"; "caddy.reverse_proxy" = "{{upstreams 5000}}"; };
        networks = [ "proxy" ];
        volumes = [ "/home/${username}/docker/changedetection:/config" ];
        };

      docker-rss = {
        autoStart = true;
        dependsOn = [ "caddy" ];
        image = "theconnman/docker-hub-rss";
        labels = { "caddy" = "dock.${domain}"; "caddy.reverse_proxy" = "{{upstreams 3000}}"; };
        networks = [ "proxy" ];
        };

      echoip = {
        autoStart = true;
        dependsOn = [ "caddy" ];
        cmd = [ "-H" "X-Forwarded-For" ];
        image = "mpolden/echoip";
        labels = { "caddy" = "ip.${domain}"; "caddy.reverse_proxy" = "{{upstreams 8080}}"; };
        networks = [ "proxy" ];
        };

      freshrss = {
        autoStart = true;
        dependsOn = [ "caddy" ];
        environment = { PGID = "100"; PUID = "1000"; TZ = "${timezone}";};
        image = "lscr.io/linuxserver/freshrss";
        labels = { "caddy" = "rss.${domain}"; "caddy.reverse_proxy" = "{{upstreams 80}}"; };
        networks = [ "proxy" ];
        volumes = [ "/home/${username}/docker/freshrss:/config" ];
        };

      h5ai = {
        autoStart = true;
        dependsOn = [ "caddy" ];
        image = "awesometic/h5ai";
        labels = { "caddy" = "pub.${domain}"; "caddy.reverse_proxy" = "{{upstreams 80}}"; "caddy.basic_auth" = "/.tank/*"; "caddy.basic_auth.${username}" = "${htpasswd}";};
        networks = [ "proxy" ];
        # volumes = [ "/home/${username}/vault/pub:/h5ai:ro" "/home/${username}/vault/src/nix-configs/resources/h5ai.css:/config/h5ai/_h5ai/public/css/styles.css" ];
        volumes = [ "/home/${username}/vault/pub:/h5ai" "/tank/complete:/h5ai/.tank" ];
        };

      hugo = {
        autoStart = true;
        dependsOn = [ "caddy" ];
        cmd = [ "server" "--watch=true" "--disableLiveReload" "--minify" "--source=/src" "--baseURL=https://${domain}" "--bind=0.0.0.0" "--appendPort=false" "--buildFuture" ];
        image = "klakegg/hugo";
        labels = { "caddy" = "${domain}, blog.${domain}, www.${domain}"; "caddy.reverse_proxy" = "{{upstreams 1313}}"; };
        networks = [ "proxy" ];
        volumes = [ "/home/${username}/vault/src/blog.${domain}:/src" ];
        };

      jackett = {
        autoStart = true;
        dependsOn = [ "caddy" ];
        environment = { PGID = "100"; PUID = "1000"; TZ = "${timezone}";};
        image = "lscr.io/linuxserver/jackett";
        labels = { "caddy" = "jack.${domain}"; "caddy.reverse_proxy" = "{{upstreams 9117}}"; };
        networks = [ "proxy" ];
        volumes = [ "/home/${username}/docker/jackett:/config" "/home/${username}/vault:/downloads" ];
        };

      stagit = {
        autoStart = true;
        dependsOn = [ "caddy" ];
        environment = { PGID = "100"; PUID = "1000";};
        image = "lscr.io/linuxserver/nginx";
        labels = { "caddy" = "git.${domain}"; "caddy.reverse_proxy" = "{{upstreams 80}}"; };
        networks = [ "proxy" ];
        volumes = [ "/home/${username}/docker/stagit:/config/www:ro" ];
        };

      # transmission
      # transmission-proxy
      # transmission-rss

      vaultwarden = {
        autoStart = true;
        dependsOn = [ "caddy" ];
        environment = { WEBSOCKET_ENABLED = "false"; SIGNUPS_ALLOWED = "false"; };
        image = "vaultwarden/server:alpine";
        labels = { "caddy" = "pass.${domain}"; "caddy.reverse_proxy" = "{{upstreams 80}}"; };
        networks = [ "proxy" ];
        volumes = [ "/home/${username}/docker/vaultwarden:/data" ];
        };

      vikunja = {
        autoStart = true;
        dependsOn = [ "caddy" ];
        environment = { PGID = "100"; PUID = "1000"; VIKUNJA_SERVICE_ENABLEREGISTRATION = "false"; VIKUNJA_SERVICE_ENABLETASKCOMMENTS = "false"; VIKUNJA_SERVICE_JWTSECRET = "${todosecret}"; VIKUNJA_SERVICE_PUBLICURL = "https://todo.${domain}/"; VIKUNJA_SERVICE_TIMEZONE = "${timezone}";};
        image = "vikunja/vikunja";
        labels = { "caddy" = "todo.${domain}"; "caddy.reverse_proxy" = "{{upstreams 3456}}"; };
        networks = [ "proxy" ];
        volumes = [ "/home/${username}/docker/vikunja:/db" ];
        };

    };
  };
}
