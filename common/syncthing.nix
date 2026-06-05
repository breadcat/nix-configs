{ vars, ... }:
{

  services.syncthing = {
    enable = true;
    user = "${vars.user.username}";
    group = "users";
    dataDir = "/home/${vars.user.username}/";
    configDir = "/home/${vars.user.username}/.config/syncthing";
    settings = {
      options.urAccepted = 3;
      devices = builtins.mapAttrs (_: id: { inherit id; }) vars.syncthing;
      folders = {
        "/home/${vars.user.username}/vault" = {
      label = "vault";
            id = "vault";
            devices = builtins.attrNames vars.syncthing;
          };
        };
      };
    };

 # https://github.com/quic-go/quic-go/wiki/UDP-Buffer-Sizes
 boot.kernel.sysctl."net.core.rmem_max" = 7500000;
 boot.kernel.sysctl."net.core.wmem_max" = 7500000;

  # Disable default ~/Sync folder
  systemd.services.syncthing.environment.STNODEFAULTFOLDER = "true";

  # Firewall ports
  networking.firewall.allowedTCPPorts = [ 22000 ];
  networking.firewall.allowedUDPPorts = [ 22000 21027 ];

}
