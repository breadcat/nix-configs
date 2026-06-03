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
      devices = {
        atlas.id = "${vars.syncthing.atlas}";
        arcadia.id = "${vars.syncthing.arcadia}";
        artemis.id = "${vars.syncthing.artemis}";
        ilias.id = "${vars.syncthing.ilias}";
        minerva.id = "${vars.syncthing.minerva}";
        phone.id = "${vars.syncthing.phone}";
        windows.id = "${vars.syncthing.windows}";
        };
      folders = {
        "/home/${vars.user.username}/vault" = {
      label = "vault";
            id = "vault";
            devices = [ "atlas" "arcadia" "artemis" "ilias" "minerva" "phone" "windows" ];
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
