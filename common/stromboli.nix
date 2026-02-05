{ config, pkgs, username, ... }:

{
  # Systemd service
  systemd.services.stromboli = {
    description = "Stromboli Go Application";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];

    serviceConfig = {
      Type = "simple";
      User = "${username}";
      WorkingDirectory = "/home/${username}/vault/src/stromboli";
      ExecStart = "${pkgs.go}/bin/go run . -d /tank/media/videos/ -p 80";
      Restart = "on-failure";
      RestartSec = "5s";
      AmbientCapabilities = "cap_net_bind_service";
      CapabilityBoundingSet = "cap_net_bind_service";
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
