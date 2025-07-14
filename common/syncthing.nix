{ username, ... }:
{

  services.syncthing = {
    enable = true;
    user = "${username}";
    dataDir = "/home/${username}/";
    configDir = "/home/${username}/.config/syncthing";
    settings = {
      options.urAccepted = 1;
      devices = {
        desktop.id = "6DL2MHG-4WS4B2Q-IAOHURV-XL3CXVZ-EBDXZMH-FZS7WFX-UJAVUJL-UQ2EOAQ";
        htpc.id = "E46LP6X-6LMHIBU-LPQTF2P-T5VIU52-OJWUAP5-ZX7VCQU-S7GGGK3-Y4IXVAJ";
        laptop.id = "L2DBXFX-T5B52M7-54AOF4S-HVGQGHM-XMEDPFI-NXX4PEI-V6YHD7P-JYGR2A3";
        nas.id = "FONKXV6-BQFMLNT-6OHTKXG-CP7DOZP-M5ZA6GW-5WAN4L6-X3LEANG-7EC5WQ6";
        phone.id = "7M34AP7-VLSE6A4-UX24I72-VDXCBSW-BGXHSUF-OF6UQQL-7QK4IFW-5F5M3QH";
        server.id = "TJV7YEI-GYLINDA-6YYHJW7-TLV6XUY-LJEJWSV-AEZ6NKE-BFLX4KB-BJ5DNAH";
        };
      folders = {
        "/home/${username}/vault" = {
	    label = "vault";
            id = "vault";
            devices = [ "desktop" "htpc" "laptop" "nas" "phone" "server" ];
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
