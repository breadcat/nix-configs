{ pkgs, username, domain, ... }:

{
  systemd.services.reverse-ssh-tunnel = {
    description = "Persistent Reverse SSH Tunnel";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      ExecStart = "${pkgs.openssh}/bin/ssh -NTg -o ServerAliveInterval=30 -o ExitOnForwardFailure=yes -o StrictHostKeyChecking=accept-new -p 55012 -i /home/${username}/vault/docs/secure/ssh-key-2022-02-16.key -R 55013:localhost:22 ${username}@${domain}";
      Restart = "always";
      RestartSec = "10s";
      User = "${username}";
    };
  };

  environment.systemPackages = with pkgs; [ openssh ];
}
