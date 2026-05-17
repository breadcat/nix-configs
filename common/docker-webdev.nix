{ config, lib, username, ... }:

let

  webdevDir = "/home/${username}/vault/src/webdev";
  domainExtensions = [ ".com" ".net" ".org" ".co.uk" ".dev" ];

  domains = builtins.attrNames (
    lib.filterAttrs
      (name: type:
        type == "directory" &&
        builtins.any (ext: lib.hasSuffix ext name) domainExtensions)
      (builtins.readDir webdevDir));

  containerName = domain: "hugo-${lib.replaceStrings ["."] ["-"] domain}";

  makeHugoContainer = domain: {
    name = containerName domain;
    value = {
      autoStart = true;
      dependsOn = [ "caddy" ];
      image = "klakegg/hugo";
      cmd = [ "server" "--watch=true" "--disableLiveReload" "--minify" "--source=/src" "--baseURL=https://${domain}" "--bind=0.0.0.0" "--appendPort=false" "--buildFuture" ];
      labels = { "caddy" = "${domain}, www.${domain}"; "caddy.reverse_proxy" = "{{upstreams 1313}}"; };
      networks = [ "proxy" ];
      volumes = [ "${webdevDir}/${domain}:/src" ];
    };
  };

in {
  virtualisation.oci-containers.containers =
    builtins.listToAttrs (map makeHugoContainer domains);
}
