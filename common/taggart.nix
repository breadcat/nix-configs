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
      # PATH = "${pkgs.go}/bin:${pkgs.git}/bin:/run/current-system/sw/bin";
      GOPATH = "/home/${username}/go";
    };

    path = [ pkgs.go pkgs.git pkgs.gcc ];
  };

  # Open firewall port
  networking.firewall.allowedTCPPorts = [ 8080 ];

}
