{ config, pkgs, vars, ... }:

{
  # Systemd service
  systemd.services.limoncello = {
    description = "Limoncello Go Application";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];

    serviceConfig = {
      Type = "simple";
      User = "${vars.user.username}";
      WorkingDirectory = "/home/${vars.user.username}/vault/src/limoncello";
      ExecStart = "${pkgs.go}/bin/go run . -f /home/${vars.user.username}/vault/src/limoncello/units.json -p 9092";
      Restart = "on-failure";
      RestartSec = "5s";
    };

    environment = {
      HOME = "/home/${vars.user.username}";
      GOPATH = "/home/${vars.user.username}/go";
    };

    path = with pkgs; [ "/run/current-system/sw" gcc go ];

  };

}
