{ config, pkgs, username, ... }:

{
  # Systemd service
  systemd.services.stromboli = {
    description = "Stromboli Go Application";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];

    serviceConfig = {
      Type = "simple";
      WorkingDirectory = "/home/${username}/vault/src/stromboli";
      ExecStart = "${pkgs.go}/bin/go run . -d /tank/media/videos/ -p 80";
      Restart = "on-failure";
      RestartSec = "5s";
    };

    environment = {
      HOME = "/home/${username}";
      GOPATH = "/home/${username}/go";
    };

    path = with pkgs; [
      ffmpeg
      gcc
      go
    ];

  };

  # Open firewall port
  networking.firewall.allowedTCPPorts = [ 80 ];

}
