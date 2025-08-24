{
    services.nfs.server = {
      enable = true;
      exports = ''
        /tank    192.168.1.0/24(rw)
      '';
    };
}
