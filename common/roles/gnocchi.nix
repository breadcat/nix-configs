{ config, pkgs, username, domain, ... }:

{
  # Systemd service
  systemd.services.gnocchi = {
    description = "Gnocchi Go Application";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];

    serviceConfig = {
      Type = "simple";
      User = "${username}";
      WorkingDirectory = "/home/${username}/vault/src/gnocchi";
      ExecStart = "${pkgs.go}/bin/go run . -f /home/${username}/vault/src/blog.${domain}/content/weight.md -p 9090";
      Restart = "on-failure";
      RestartSec = "5s";
    };

    environment = {
      HOME = "/home/${username}";
      GOPATH = "/home/${username}/go";
    };

    path = with pkgs; [
      "/run/current-system/sw" # find blog-weight script here
      gcc
      go
    ];

  };

  # Open firewall port
  networking.firewall.allowedTCPPorts = [ 9090 ];

}
