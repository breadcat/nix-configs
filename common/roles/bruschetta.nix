{ config, pkgs, username, domain, ... }:

{
  # Systemd service
  systemd.services.bruschetta = {
    description = "Bruschetta Go Application";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];

    serviceConfig = {
      Type = "simple";
      User = "${username}";
      WorkingDirectory = "/home/${username}/vault/src/bruschetta";
      ExecStart = "${pkgs.go}/bin/go run . -d /home/${username}/vault/pub -p 9091";
      Restart = "on-failure";
      RestartSec = "5s";
    };

    environment = {
      HOME = "/home/${username}";
      GOPATH = "/home/${username}/go";
    };

    path = with pkgs; [
      gcc
      go
    ];

  };

}
