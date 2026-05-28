{ config, pkgs, vars, ... }:

{
  # Systemd service
  systemd.services.tagliatelle = {
    description = "Tagliatelle Go Application";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];

    serviceConfig = {
      Type = "simple";
      User = "${vars.user.username}";
      WorkingDirectory = "/home/${vars.user.username}/vault/src/tagliatelle";
      ExecStart = "${pkgs.go}/bin/go run . -d /tank/.x/tagliatelle -p 9816";
      Restart = "on-failure";
      RestartSec = "5s";
    };

    environment = {
      HOME = "/home/${vars.user.username}";
      GOPATH = "/home/${vars.user.username}/go";
    };

    path = with pkgs; [ ffmpeg gcc git go yt-dlp ];

  };

  # Open firewall port
  networking.firewall.allowedTCPPorts = [ 9816 ];

}
