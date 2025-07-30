{ pkgs, username, ... }:

let
  backup-cloud = pkgs.writeShellScriptBin "backup-cloud" ''
      # variables
      directories=( "$HOME/docker/" "$HOME/vault/" )
      # process
      source "$HOME/vault/docs/secure/restic.env"
      # Directory loop
      for dir in "''${directories[@]}"; do
        if [[ -d "$dir" ]]; then
          echo "Directory exists: $dir"
          ${pkgs.restic}/bin/restic backup "$dir"
        else
          echo "Directory does not exist: $dir"
        fi
      done
  '';
in {
  environment.systemPackages = [ backup-cloud ];

  systemd.services.restic-backup = {
    description = "Backup specific directories to BorgBase";
    script = "backup-cloud";
    serviceConfig = {
      Type = "oneshot";
      User = "${username}";
      # ExecStart = "${backup-cloud}/bin/backup-cloud";
    };
  };

  systemd.timers.restic-backup = {
    description = "Timer to run Restic backup";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnActiveSec = "12h";
      Persistent = true;
    };
  };
}
