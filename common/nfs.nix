{
  fileSystems."/mnt" = {
    device = "192.168.1.3:/mnt";
    fsType = "nfs";
    options = [ "x-systemd.automount" "noauto" ];
    };
}