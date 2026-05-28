{ config, pkgs, vars, ... }:

{
  # Systemd service
  systemd.services.gnocchi = {
    description = "Gnocchi Go Application";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];

    serviceConfig = {
      Type = "simple";
      User = "${vars.user.username}";
      WorkingDirectory = "/home/${vars.user.username}/vault/src/gnocchi";
      ExecStart = "${pkgs.go}/bin/go run . -f /home/${vars.user.username}/vault/src/blog.${vars.user.domain}/content/weight.md -p 9090";
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
