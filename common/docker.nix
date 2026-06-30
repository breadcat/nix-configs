{ pkgs, vars, ... }: {

  # Runtime
  virtualisation.docker.enable = true;
  virtualisation.docker.autoPrune.enable = true;
  users.extraUsers.${vars.user.username}.extraGroups = ["docker"];

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
        labels = { "caddy" = "dav.${vars.user.domain}"; "caddy.reverse_proxy" = "{{upstreams 80}}"; };
        networks = [ "proxy" ];
        volumes = [ "/home/${vars.user.username}/docker/baikal:/var/www/baikal/Specific" "/home/${vars.user.username}/docker/baikal:/var/www/baikal/config" ];
        };

      caddy = {
        autoStart = true;
        environment = { CADDY_INGRESS_NETWORKS = "proxy"; };
        image = "lucaslorentz/caddy-docker-proxy";
        networks = [ "proxy" ];
        ports = [ "80:80" "443:443" ];
        volumes = [ "/var/run/docker.sock:/var/run/docker.sock" "/home/${vars.user.username}/docker/caddy:/data" ];
        };

      changedetection = {
        autoStart = true;
        dependsOn = [ "caddy" ];
        environment = { PGID = "100"; PUID = "1000"; LC_ALL = "en_US.UTF-8";};
        image = "lscr.io/linuxserver/changedetection.io";
        labels = { "caddy" = "diff.${vars.user.domain}"; "caddy.reverse_proxy" = "{{upstreams 5000}}"; };
        networks = [ "proxy" ];
        volumes = [ "/home/${vars.user.username}/docker/changedetection:/config" ];
        };

      docker-rss = {
        autoStart = true;
        dependsOn = [ "caddy" ];
        image = "theconnman/docker-hub-rss";
        labels = { "caddy" = "dock.${vars.user.domain}"; "caddy.reverse_proxy" = "{{upstreams 3000}}"; };
        networks = [ "proxy" ];
        };

      echoip = {
        autoStart = true;
        dependsOn = [ "caddy" ];
        cmd = [ "-H" "X-Forwarded-For" ];
        image = "mpolden/echoip";
        labels = { "caddy" = "ip.${vars.user.domain}"; "caddy.reverse_proxy" = "{{upstreams 8080}}"; };
        networks = [ "proxy" ];
        };

      freshrss = {
        autoStart = true;
        dependsOn = [ "caddy" ];
        environment = { PGID = "100"; PUID = "1000"; TZ = "${vars.user.timezone}";};
        image = "lscr.io/linuxserver/freshrss";
        labels = { "caddy" = "rss.${vars.user.domain}"; "caddy.reverse_proxy" = "{{upstreams 80}}"; };
        networks = [ "proxy" ];
        volumes = [ "/home/${vars.user.username}/docker/freshrss:/config" ];
        };

      h5ai = {
        autoStart = true;
        dependsOn = [ "caddy" ];
        environment = { PGID = "100"; PUID = "1000"; TZ = "${vars.user.timezone}";};
        image = "awesometic/h5ai";
        labels = { "caddy" = "pub.${vars.user.domain}"; "caddy.reverse_proxy" = "{{upstreams 80}}"; "caddy.basic_auth" = "/.tank/*"; "caddy.basic_auth.${vars.user.username}" = "${vars.secrets.htpasswd}";};
        networks = [ "proxy" ];
        volumes = [ "/home/${vars.user.username}/vault/pub:/h5ai" "/tank/complete:/h5ai/.tank" "/home/${vars.user.username}/docker/h5ai:/config/h5ai/" ];
        };

      hugo = {
        autoStart = true;
        dependsOn = [ "caddy" ];
        cmd = [ "server" "--watch=true" "--disableLiveReload" "--minify" "--source=/src" "--baseURL=https://${vars.user.domain}" "--bind=0.0.0.0" "--appendPort=false" "--buildFuture" ];
        image = "klakegg/hugo";
        labels = { "caddy" = "${vars.user.domain}, blog.${vars.user.domain}, www.${vars.user.domain}"; "caddy.reverse_proxy" = "{{upstreams 1313}}"; };
        networks = [ "proxy" ];
        volumes = [ "/home/${vars.user.username}/vault/src/blog.${vars.user.domain}:/src" ];
        };

      jackett = {
        autoStart = true;
        dependsOn = [ "caddy" ];
        environment = { PGID = "100"; PUID = "1000"; TZ = "${vars.user.timezone}";};
        image = "lscr.io/linuxserver/jackett";
        labels = { "caddy" = "jack.${vars.user.domain}"; "caddy.reverse_proxy" = "{{upstreams 9117}}"; };
        networks = [ "proxy" ];
        volumes = [ "/home/${vars.user.username}/docker/jackett:/config" "/home/${vars.user.username}/vault/watch:/downloads" ];
        };

      stagit = {
        autoStart = true;
        dependsOn = [ "caddy" ];
        environment = { PGID = "100"; PUID = "1000";};
        image = "lscr.io/linuxserver/nginx";
        labels = { "caddy" = "git.${vars.user.domain}"; "caddy.reverse_proxy" = "{{upstreams 80}}"; };
        networks = [ "proxy" ];
        volumes = [ "/home/${vars.user.username}/docker/stagit:/config/www:ro" ];
        };

      transmission = {
        autoStart = true;
        capabilities = { NET_ADMIN = true; };
        dependsOn = [ "caddy" ];
        devices = [ "/dev/net/tun" ];
        environment = { PGID = "100"; PUID = "1000"; LOCAL_NETWORK = "10.0.0.0/24"; NORDVPN_CATEGORY = "p2p"; NORDVPN_COUNTRY = "GB"; OPENVPN_PASSWORD = "${vars.secrets.vpnpassword}";  OPENVPN_PROVIDER = "NORDVPN"; OPENVPN_USERNAME = "${vars.secrets.vpnusername}"; };
        extraOptions = [ "--dns=8.8.8.8" "--dns=9.9.9.9" ];
        image = "haugene/transmission-openvpn";
        networks = [ "proxy" ];
        ports = [ "9091:9091" "51413:51413" ];
        volumes = [ "/tank/complete:/data/completed" "/tank/incomplete:/data/incomplete" "/home/${vars.user.username}/docker/transmission:/data/transmission-home" "/home/${vars.user.username}/vault/watch:/data/watch" ];
        };

      transmission-proxy = {
        autoStart = true;
        dependsOn = [ "caddy" "transmission" ];
        extraOptions = [ "--link=transmission" ];
        image = "haugene/transmission-openvpn-proxy";
        labels = { "caddy" = "tor.${vars.user.domain}"; "caddy.reverse_proxy" = "{{upstreams 8080}}"; "caddy.basic_auth" = "*"; "caddy.basic_auth.${vars.user.username}" = "${vars.secrets.htpasswd}";};
        networks = [ "proxy" ];
        };

      transmission-rss = {
        autoStart = true;
        dependsOn = [ "transmission" ];
        environment = { GID = "100"; UID = "1000"; };
        extraOptions = [ "--link=transmission" ];
        image = "haugene/transmission-rss";
        networks = [ "proxy" ];
        volumes = [ "/home/${vars.user.username}/docker/transmission-rss/config:/etc/transmission-rss.conf" "/home/${vars.user.username}/docker/transmission-rss/seen:/etc/transmission-rss.seen" ];
        };

      vaultwarden = {
        autoStart = true;
        dependsOn = [ "caddy" ];
        environment = { WEBSOCKET_ENABLED = "false"; SIGNUPS_ALLOWED = "false"; };
        image = "vaultwarden/server:alpine";
        labels = { "caddy" = "pass.${vars.user.domain}"; "caddy.reverse_proxy" = "{{upstreams 80}}"; };
        networks = [ "proxy" ];
        volumes = [ "/home/${vars.user.username}/docker/vaultwarden:/data" ];
        };

      vikunja = {
        autoStart = true;
        dependsOn = [ "caddy" ];
        environment = { PGID = "100"; PUID = "1000"; VIKUNJA_SERVICE_ENABLEREGISTRATION = "false"; VIKUNJA_SERVICE_ENABLETASKCOMMENTS = "false"; VIKUNJA_SERVICE_JWTSECRET = "${vars.secrets.todosecret}"; VIKUNJA_SERVICE_PUBLICURL = "https://todo.${vars.user.domain}/"; VIKUNJA_SERVICE_TIMEZONE = "${vars.user.timezone}";};
        image = "vikunja/vikunja";
        labels = { "caddy" = "todo.${vars.user.domain}"; "caddy.reverse_proxy" = "{{upstreams 3456}}"; };
        networks = [ "proxy" ];
        volumes = [ "/home/${vars.user.username}/docker/vikunja/db:/db" "/home/${vars.user.username}/docker/vikunja/files:/app/vikunja/files" ];
        };

      watchtower = {
        autoStart = true;
        image = "containrrr/watchtower";
        environment = { WATCHTOWER_CLEANUP = "true"; WATCHTOWER_INCLUDE_RESTARTING = "true"; WATCHTOWER_SCHEDULE = "0 0 4 * * *"; };
        volumes = [ "/var/run/docker.sock:/var/run/docker.sock" ];
        };

    };
  };
}
