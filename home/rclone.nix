{ username, domain, sshport, privatekey, ... }:

{
  programs.rclone = {
    enable = true;
    remotes = {
      artemis.config = {
        type = "sftp";
        host = "${domain}";
        port = sshport;
        user = "${username}";
        key_file = "${privatekey}";
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
        key_file = "${privatekey}";
        };
      nas.config = {
        type = "alias";
        remote = "/tank/media";
        };
      myrient.config = {
        type = "http";
        url = "https://myrient.erista.me/files/";
        };
      };
    };
}
