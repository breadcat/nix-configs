{ config, pkgs, username, ... }:

{
  # Systemd service
  systemd.services.taggart = {
    description = "Taggart Go Application";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];

    serviceConfig = {
      Type = "simple";
      User = "${username}";
      WorkingDirectory = "/home/${username}/vault/src/taggart";
      ExecStart = "${pkgs.go}/bin/go run .";
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
      git
      go
      yt-dlp
    ];

  };

  # Open firewall port
  networking.firewall.allowedTCPPorts = [ 8080 ];

}
