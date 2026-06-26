{ config, pkgs, vars, ... }:

{
  # Systemd service
  systemd.services.stromboli = {
    description = "Stromboli Go Application";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];

    serviceConfig = {
      Type = "simple";
      User = "${vars.user.username}";
      WorkingDirectory = "/home/${vars.user.username}/vault/src/stromboli";
      ExecStart = "${pkgs.go}/bin/go run . -d /tank/media/videos/ -p 8080";
      Restart = "on-failure";
      RestartSec = "5s";
    };

    environment = {
      HOME = "/home/${vars.user.username}";
      GOPATH = "/home/${vars.user.username}/go";
    };

    path = with pkgs; [ ffmpeg gcc go ];

  };

  # Firewall port
  networking.firewall.allowedTCPPorts = [ 8080 ];

}
