{ pkgs, vars, ... }:

{
  environment.systemPackages = [ pkgs.rclone ];
  programs.fuse.userAllowOther = true;

  fileSystems."/home/${vars.user.username}/seedbox" = {
    device = "seedbox:";
    fsType = "rclone";
    options = [
      "nodev"
      "nofail"
      "noauto"
      "_netdev"
      "allow_other"
      "args2env"
      "config=/home/${vars.user.username}/.config/rclone/rclone.conf"
      "uid=1000"
      "gid=100"
      "vfs-cache-mode=writes"
      "x-systemd.automount"
      "x-systemd.idle-timeout=300"     # unmount after 5 min idle
      "x-systemd.mount-timeout=30"
    ];
  };
}
