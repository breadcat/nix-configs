{ pkgs, vars, ... }:

{
  systemd.services.reverse-ssh-tunnel = {
    description = "Persistent Reverse SSH Tunnel";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      ExecStart = "${pkgs.openssh}/bin/ssh -NTg -o ServerAliveInterval=30 -o ExitOnForwardFailure=yes -o StrictHostKeyChecking=accept-new -p ${toString vars.secrets.sshport} -i ${vars.secrets.privatekey} -R 55013:localhost:${toString vars.secrets.sshport} ${vars.user.username}@${vars.user.domain}";
      Restart = "always";
      RestartSec = "10s";
      User = "${vars.user.username}";
    };
  };

  environment.systemPackages = with pkgs; [ openssh ];
}
