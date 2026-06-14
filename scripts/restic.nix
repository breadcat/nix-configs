{ pkgs, vars, ... }:

let
  backup-cloud = pkgs.writeShellScriptBin "backup-cloud" ''
      # variables
      directories=( "$HOME/docker/" "$HOME/vault/" )
      excludes=( "*.flac" "*.jpg" "*.jpeg" "*.mp4" "*.webm" "*.mkv")
      source "$HOME/vault/docs/secure/restic.env"

      case "''${1:-backup}" in
        prune)
          echo "Running restic retention policy..."
          ${pkgs.restic}/bin/restic forget \
            --group-by host,paths \
            --keep-daily 7 \
            --keep-weekly 4 \
            --keep-monthly 6 \
            --keep-yearly 2 \
            --prune
          ;;
        backup)
          exclude_args=()
          for ext in "''${excludes[@]}"; do
            exclude_args+=("--exclude=$ext")
          done
          for dir in "''${directories[@]}"; do
            if [[ -d "$dir" ]]; then
              echo "Directory exists: $dir"
              ${pkgs.restic}/bin/restic backup "$dir" "''${exclude_args[@]}"
            else
              echo "Directory does not exist: $dir"
            fi
          done
          ;;
        *)
          echo "Usage: backup-cloud [backup|prune]"
          exit 1
          ;;
      esac
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
