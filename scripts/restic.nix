{ pkgs, vars, ... }:

let
  backup-cloud = pkgs.writeShellScriptBin "backup-cloud" ''
      # variables
      directories=( "$HOME/docker/" "$HOME/vault/" )
      excludes=( "*.flac" "*.jpg" "*.jpeg" "*.mp4" "*.webm" "*.mkv")
      exclude_args=()
      for ext in "''${excludes[@]}"; do
        exclude_args+=("--exclude=$ext")
      done
      # process
      source "$HOME/vault/docs/secure/restic.env"
      # Directory loop
      for dir in "''${directories[@]}"; do
        if [[ -d "$dir" ]]; then
          echo "Directory exists: $dir"
          ${pkgs.restic}/bin/restic backup "$dir" "''${exclude_args[@]}"
        else
          echo "Directory does not exist: $dir"
        fi
      done
  '';
in {
  environment.systemPackages = [ backup-cloud ];

  systemd.services.backup-cloud = {
    description = "Restic cloud backup";
    serviceConfig = {
      Type = "oneshot";
      User = vars.user.username;
      ExecStart = "${backup-cloud}/bin/backup-cloud";
      Environment = "PATH=/run/current-system/sw/bin:/run/wrappers/bin";
    };
  };

  systemd.timers.backup-cloud = {
    description = "Run backup-cloud every 12 hours at a random offset";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "*-*-* 00/12:00:00";
      RandomizedDelaySec = "6h";
      Persistent = true;
    };
  };
}
