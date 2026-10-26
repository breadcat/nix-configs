{
  fileSystems."/tank" = {
    device = "192.168.1.3:/tank";
    fsType = "nfs";
    options = [ "x-systemd.automount" "x-systemd.idle-timeout=0" "noauto" "nfsvers=4.2" ];
    };
}
