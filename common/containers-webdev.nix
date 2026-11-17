{ config, lib, vars, ... }:

let
  webdevDir = "/home/${vars.user.username}/vault/src/webdev";
  domainExtensions = [ ".com" ".net" ".org" ".co.uk" ];

  domains = builtins.attrNames (
    lib.filterAttrs
      (name: type:
        type == "directory" &&
        builtins.any (ext: lib.hasSuffix ext name) domainExtensions)
      (builtins.readDir webdevDir)
  );
  containerName = domain:
    "hugo-${lib.replaceStrings [ "." ] [ "-" ] domain}";
  makeHugoContainer = domain:
    let name = containerName domain;
    in
    {
      name = name;
      value = {
        autoStart = true;
        cmd = [ "server" "--watch=true" "--disableLiveReload" "--minify" "--source=/src" "--baseURL=https://${domain}" "--bind=0.0.0.0" "--appendPort=false" "--buildFuture" "--renderToMemory" ];
        dependsOn = [ "traefik" ];
        image = "ghcr.io/gohugoio/hugo";
        networks = [ "proxy" ];
        user = "1000:100";
        volumes = [ "${webdevDir}/${domain}:/src" ];
        labels = {
          "io.containers.autoupdate" = "registry";
          "traefik.enable" = "true";
          "traefik.docker.network" = "proxy";
          "traefik.http.routers.${name}.rule" = "Host(`${domain}`) || Host(`www.${domain}`)";
          "traefik.http.routers.${name}.entrypoints" = "websecure";
          "traefik.http.services.${name}.loadbalancer.server.port" = "1313";
          "traefik.http.routers.${name}.tls" = "true";
          "traefik.http.routers.${name}.tls.certresolver" = "http";
        };
      };
    };

in
{
  virtualisation.oci-containers.containers =
    builtins.listToAttrs (map makeHugoContainer domains);
}
