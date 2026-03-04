{
  services.nfs.server = {
    enable = true;
    exports = ''
      /tank    192.168.1.0/24(rw)
    '';
  };
  networking.firewall = {
      allowedTCPPorts = [ 111 2049 ];
      allowedUDPPorts = [ 111 2049 ];
    };
}
