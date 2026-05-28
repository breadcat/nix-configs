{ config, pkgs, vars, ... }:

{
  # Systemd service
  systemd.services.bruschetta = {
    description = "Bruschetta Go Application";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];

    serviceConfig = {
      Type = "simple";
      User = "${vars.user.username}";
      WorkingDirectory = "/home/${vars.user.username}/vault/src/bruschetta";
      ExecStart = "${pkgs.go}/bin/go run . -d /home/${vars.user.username}/vault/pub -p 9091";
      Restart = "on-failure";
      RestartSec = "5s";
    };

    environment = {
      HOME = "/home/${vars.user.username}";
      GOPATH = "/home/${vars.user.username}/go";
    };

    path = with pkgs; [ gcc go ];

  };

}
