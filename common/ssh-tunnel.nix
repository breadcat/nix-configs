{ pkgs, username, domain, sshport, privatekey, ... }:

{
  systemd.services.reverse-ssh-tunnel = {
    description = "Persistent Reverse SSH Tunnel";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      ExecStart = "${pkgs.openssh}/bin/ssh -NTg -o ServerAliveInterval=30 -o ExitOnForwardFailure=yes -o StrictHostKeyChecking=accept-new -p ${toString sshport} -i ${privatekey} -R 55013:localhost:22 ${username}@${domain}";
      Restart = "always";
      RestartSec = "10s";
      User = "${username}";
    };
  };

  environment.systemPackages = with pkgs; [ openssh ];
}
