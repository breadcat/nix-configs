{ pkgs, ... }:

let
  backup-cloud = pkgs.writeShellScriptBin "backup-cloud" ''
      # variables
      directories=( "$HOME/docker/" "$HOME/vault/" )
      excludes=( "*.jpg" "*.jpeg" "*.mp4" "*.webm" "*.mkv" )
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
}
