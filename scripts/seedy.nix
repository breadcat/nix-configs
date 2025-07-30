{ pkgs, ... }:

let
  seedy = pkgs.writeShellScriptBin "seedy" ''
    # default remote, or specify via argument
    remote_default="seedbox:"
    remote="''${1:-$remote_default}"
    # variables
    selection="$(rclone lsf "$remote" | fzf)"
    if [[ -z "$selection" ]]; then
      echo "No files were selected, exiting."
      exit 1
    fi
    printf "Copying %s...\n" "$selection"
    ${pkgs.rclone}/bin/rclone copy "$remote""$selection" . --transfers=1 --progress
  '';
in {
  environment.systemPackages = [ seedy ];
}
