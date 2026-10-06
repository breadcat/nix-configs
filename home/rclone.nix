{ vars, ... }:

{
  programs.rclone = {
    enable = true;
    remotes = {
      artemis.config = {
        type = "sftp";
        host = vars.user.domain;
        port = vars.secrets.sshport;
        user = vars.user.username;
        key_file = vars.secrets.privatekey;
        known_hosts_file = "none";
        shell_type = "cmd";
        };
      seedbox.config = {
        type = "alias";
        remote = "artemis:/tank/complete";
        };
      incomplete.config = {
        type = "alias";
        remote = "artemis:/tank/incomplete";
        };
      phone.config = {
        type = "sftp";
        host = "phone";
        port = "1234";
        user = "ftp";
        key_file = vars.secrets.privatekey;
        known_hosts_file = "none";
        };
      nas.config = {
        type = "alias";
        remote = "/tank/media";
        };
      };
    };
}
