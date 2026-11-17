{ lib, pkgs, vars, ... }:

let
  autoUpdate = { "io.containers.autoupdate" = "registry"; };
  routeLabels = router: hostRule: port: extraLabels:
    {
      "traefik.enable" = "true";
      "traefik.docker.network" = "proxy";
      "traefik.http.routers.${router}.rule" = hostRule;
      "traefik.http.routers.${router}.entrypoints" = "websecure";
      "traefik.http.services.${router}.loadbalancer.server.port" = toString port;
    } // extraLabels;

  host = subdomain: "Host(`${subdomain}.${vars.user.domain}`)";
in
{
  # Runtime
  virtualisation.podman = {
    enable = true;
    dockerSocket.enable = true;
    defaultNetwork.settings.dns_enabled = true;
  };

  virtualisation.oci-containers = {
    backend = "podman";
    containers = {
      traefik = {
        autoStart = true;
        environment = { CF_DNS_API_TOKEN = vars.secrets.cloudflare; };
        image = "docker.io/library/traefik:v3";
        labels = autoUpdate;
        networks = [ "proxy" ];
        ports = [ "80:80" "443:443" ];
        volumes = [ "/run/podman/podman.sock:/var/run/docker.sock" "/home/${vars.user.username}/docker/traefik/acme.json:/letsencrypt/acme.json" "/home/${vars.user.username}/docker/traefik/acme-http.json:/letsencrypt/acme-http.json" ];
        cmd = [
          "--api.dashboard=true"
          "--providers.docker=true"
          "--providers.docker.endpoint=unix:///var/run/docker.sock"
          "--providers.docker.exposedbydefault=false"
          "--providers.docker.network=proxy"
          "--providers.docker.watch=true"
          "--entrypoints.web.address=:80"
          "--entrypoints.web.http.redirections.entrypoint.to=websecure"
          "--entrypoints.web.http.redirections.entrypoint.scheme=https"
          "--entrypoints.websecure.address=:443"
          # DNS resolver by default
          "--entrypoints.websecure.http.tls.certresolver=cloudflare"
          "--certificatesresolvers.cloudflare.acme.email=${vars.user.email}"
          "--certificatesresolvers.cloudflare.acme.storage=/letsencrypt/acme.json"
          "--certificatesresolvers.cloudflare.acme.dnschallenge.provider=cloudflare"
          # HTTP resolver backup for webdev
          "--certificatesresolvers.http.acme.email=${vars.user.email}"
          "--certificatesresolvers.http.acme.storage=/letsencrypt/acme-http.json"
          "--certificatesresolvers.http.acme.httpchallenge.entrypoint=web"
        ];
      };

      baikal = {
        autoStart = true;
        dependsOn = [ "traefik" ];
        image = "docker.io/ckulka/baikal:nginx";
        labels = autoUpdate // routeLabels "baikal" (host "dav") 80 { };
        networks = [ "proxy" ];
        volumes = [ "/home/${vars.user.username}/docker/baikal:/var/www/baikal/Specific" "/home/${vars.user.username}/docker/baikal:/var/www/baikal/config" ];
      };

      changedetection = {
        autoStart = true;
        dependsOn = [ "traefik" ];
        environment = { PGID = "100"; PUID = "1000"; LC_ALL = "en_US.UTF-8"; };
        image = "lscr.io/linuxserver/changedetection.io";
        labels = autoUpdate // routeLabels "changedetection" (host "diff") 5000 { };
        networks = [ "proxy" ];
        volumes = [ "/home/${vars.user.username}/docker/changedetection:/config" ];
      };

      echoip = {
        autoStart = true;
        cmd = [ "-H" "X-Forwarded-For" ];
        dependsOn = [ "traefik" ];
        image = "docker.io/mpolden/echoip";
        labels = autoUpdate // routeLabels "echoip" (host "ip") 8080 { };
        networks = [ "proxy" ];
      };

      freshrss = {
        autoStart = true;
        dependsOn = [ "traefik" ];
        environment = { PGID = "100"; PUID = "1000"; TZ = vars.user.timezone; };
        image = "lscr.io/linuxserver/freshrss";
        labels = autoUpdate // routeLabels "freshrss" (host "rss") 80 { };
        networks = [ "proxy" ];
        volumes = [ "/home/${vars.user.username}/docker/freshrss:/config" ];
      };

      h5ai = {
        autoStart = true;
        dependsOn = [ "traefik" ];
        environment = { PGID = "100"; PUID = "1000"; TZ = vars.user.timezone; };
        image = "docker.io/awesometic/h5ai";
        networks = [ "proxy" ];
        volumes = [ "/home/${vars.user.username}/vault/pub:/h5ai" "/tank/complete:/h5ai/.tank" "/home/${vars.user.username}/docker/h5ai:/config/h5ai/" ];
        labels = autoUpdate // {
          "traefik.enable" = "true";
          "traefik.docker.network" = "proxy";
          # Public h5ai content.
          "traefik.http.routers.h5ai.rule" = host "pub";
          "traefik.http.routers.h5ai.entrypoints" = "websecure";
          # Protect only the .tank directory
          "traefik.http.routers.h5ai-protected.rule" = "${host "pub"} && PathPrefix(`/.tank/`)";
          "traefik.http.routers.h5ai-protected.entrypoints" = "websecure";
          "traefik.http.routers.h5ai-protected.priority" = "100";
          "traefik.http.routers.h5ai-protected.middlewares" = "h5ai-auth";
          "traefik.http.middlewares.h5ai-auth.basicauth.users" = "${vars.user.username}:${vars.secrets.htpasswd}";
          "traefik.http.services.h5ai.loadbalancer.server.port" = "80";
        };
      };

      hugo = {
        autoStart = true;
        cmd = [ "server" "--watch=true" "--disableLiveReload" "--minify" "--source=/src" "--baseURL=https://${vars.user.domain}" "--bind=0.0.0.0" "--appendPort=false" "--buildFuture" "--renderToMemory" ];
        dependsOn = [ "traefik" ];
        image = "ghcr.io/gohugoio/hugo";
        labels = autoUpdate // routeLabels "hugo" "Host(`${vars.user.domain}`) || Host(`blog.${vars.user.domain}`) || Host(`www.${vars.user.domain}`)" 1313 { };
        networks = [ "proxy" ];
        user = "1000:100";
        volumes = [ "/home/${vars.user.username}/vault/src/blog.${vars.user.domain}:/src" ];
      };

      jackett = {
        autoStart = true;
        dependsOn = [ "traefik" ];
        environment = { PGID = "100"; PUID = "1000"; TZ = vars.user.timezone; };
        image = "lscr.io/linuxserver/jackett";
        labels = autoUpdate // routeLabels "jackett" (host "jack") 9117 { };
        networks = [ "proxy" ];
        volumes = [ "/home/${vars.user.username}/docker/jackett:/config" "/home/${vars.user.username}/vault/watch:/downloads" ];
      };

      stagit = {
        autoStart = true;
        dependsOn = [ "traefik" ];
        environment = { PGID = "100"; PUID = "1000"; };
        image = "lscr.io/linuxserver/nginx";
        labels = autoUpdate // routeLabels "stagit" (host "git") 80 { };
        networks = [ "proxy" ];
        volumes = [ "/home/${vars.user.username}/docker/stagit:/config/www:ro" ];
      };

      transmission = {
        autoStart = true;
        capabilities = { NET_ADMIN = true; NET_RAW = true; MKNOD = true; };
        dependsOn = [ "traefik" ];
        devices = [ "/dev/net/tun:/dev/net/tun" ];
        environment = { PGID = "100"; PUID = "1000"; LOCAL_NETWORK = "10.0.0.0/24"; NORDVPN_CATEGORY = "p2p"; NORDVPN_COUNTRY = "GB"; OPENVPN_PASSWORD = vars.secrets.vpnpassword; OPENVPN_PROVIDER = "NORDVPN"; OPENVPN_USERNAME = vars.secrets.vpnusername; };
        extraOptions = [ "--dns=8.8.8.8" "--dns=9.9.9.9" ];
        image = "docker.io/haugene/transmission-openvpn";
        networks = [ "proxy" ];
        ports = [ "9091:9091" "51413:51413" ];
        volumes = [ "/tank/complete:/data/completed" "/tank/incomplete:/data/incomplete" "/home/${vars.user.username}/docker/transmission:/data/transmission-home" "/home/${vars.user.username}/vault/watch:/data/watch" ];
      };

      transmission-proxy = {
        autoStart = true;
        dependsOn = [ "traefik" "transmission" ];
        image = "docker.io/haugene/transmission-openvpn-proxy";
        networks = [ "proxy" ];
        labels = autoUpdate // routeLabels "transmission-proxy" (host "tor") 8080 {
          "traefik.http.routers.transmission-proxy.middlewares" = "transmission-auth";
          "traefik.http.middlewares.transmission-auth.basicauth.users" =
            "${vars.user.username}:${vars.secrets.htpasswd}";
        };
      };

      transmission-rss = {
        autoStart = true;
        dependsOn = [ "transmission" ];
        environment = { GID = "100"; UID = "1000"; };
        image = "docker.io/haugene/transmission-rss";
        labels = autoUpdate;
        networks = [ "proxy" ];
        volumes = [ "/home/${vars.user.username}/docker/transmission-rss/config:/etc/transmission-rss.conf" "/home/${vars.user.username}/docker/transmission-rss/seen:/etc/transmission-rss.seen" ];
      };

      vaultwarden = {
        autoStart = true;
        dependsOn = [ "traefik" ];
        environment = { WEBSOCKET_ENABLED = "false"; SIGNUPS_ALLOWED = "false"; };
        image = "docker.io/vaultwarden/server:alpine";
        labels = autoUpdate // routeLabels "vaultwarden" (host "pass") 80 { };
        networks = [ "proxy" ];
        volumes = [ "/home/${vars.user.username}/docker/vaultwarden:/data" ];
      };
    };
  };

  # Create the shared Podman network before Traefik starts.
  systemd.services.podman-create-proxy-network = {
    description = "Create the shared Podman proxy network";
    wantedBy = [ "multi-user.target" ];
    wants = [ "network-online.target" ];
    after = [ "network-online.target" ];
    before = [ "podman-traefik.service" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      ${pkgs.podman}/bin/podman network exists proxy ||
        ${pkgs.podman}/bin/podman network create proxy
    '';
  };

  # Traefik needs the Podman API socket and the proxy network.
  systemd.services.podman-traefik = { requires = [ "podman-create-proxy-network.service" "podman.socket" ]; after = [ "podman-create-proxy-network.service" "podman.socket" ]; };

  # Preserve the restart behaviour previously used for the VPN container.
  systemd.services.podman-transmission.serviceConfig = { Restart = lib.mkForce "always"; RestartSec = "10s"; };

  # Secure access to ACME state files
  systemd.tmpfiles.rules = [
    "d /home/${vars.user.username}/docker/traefik 0700 root root -"
    "f /home/${vars.user.username}/docker/traefik/acme.json 0600 root root -"
    "f /home/${vars.user.username}/docker/traefik/acme-http.json 0600 root root -"
  ];

  # Podman native updater to replace watchtower
  systemd.services.podman-auto-update-0400 = {
    description = "Update Podman containers from their registries";
    wants = [ "network-online.target" ]; after = [ "network-online.target" ];
    serviceConfig = { Type = "oneshot"; ExecStart = "${pkgs.podman}/bin/podman auto-update"; };
  };
  systemd.timers.podman-auto-update-0400 = {
    description = "Run Podman auto-update daily at 04:00";
    wantedBy = [ "timers.target" ];
    timerConfig = { OnCalendar = "*-*-* 04:00:00"; Persistent = true; };
  };

  # Firewall
  networking.firewall.allowedTCPPorts = [ 80 443 ];

  # Passwordless sudo access to podman commands for blog-status.nix
  security.sudo.extraRules = [
  {
    users = [ vars.user.username ];
    commands = [
      { command = "${pkgs.podman}/bin/podman ps -q"; options = [ "NOPASSWD" ]; }
      { command = "${pkgs.podman}/bin/podman ps -aq"; options = [ "NOPASSWD" ]; }
    ];
  }
];
}
