{ pkgs, ... }:

let
  media-sort = pkgs.callPackage ../common/media-sort.nix {};

  tank-sort = pkgs.writeShellScriptBin "tank-sort" ''
	set -euo pipefail  # Exit on any error

	# variables
	temp_mount="$(mktemp -d)"
	rclone_remote="seedbox:"
	destination_tvshows="/tank/media/videos/television"
	template_tvshows="{{ .Name }}/{{ .Name }} S{{ printf \"%02d\" .Season }}E{{ printf \"%02d\" .Episode }}{{ if ne .ExtraEpisode -1 }}-{{ printf \"%02d\" .ExtraEpisode }}{{end}}.{{ .Ext }}"
	destination_movies="/tank/media/videos/movies"
	template_movies="{{ .Name }} ({{ .Year }})/{{ .Name }}.{{ .Ext }}"

	# Cleanup function
	cleanup() {
	  echo "Cleaning up..."
	  if mountpoint -q "$temp_mount" 2>/dev/null; then
		fusermount -uz "$temp_mount" 2>/dev/null || true
	  fi
	  if [ -d "$temp_mount" ]; then
		rmdir "$temp_mount" 2>/dev/null || true
	  fi
	}
	trap cleanup EXIT

	# mount remote
	echo "Mounting rclone remote..."
	if ! ${pkgs.rclone}/bin/rclone mount "$rclone_remote" "$temp_mount" \
		--vfs-cache-mode writes \
		--daemon-timeout 10s \
		--daemon; then
	  echo "ERROR: Failed to mount rclone remote"
	  exit 1
	fi

	# Wait for mount to be ready
	echo "Waiting for mount to be ready..."
	for i in {1..30}; do
	  if mountpoint -q "$temp_mount" 2>/dev/null; then
		echo "Mount is ready"
		break
	  fi
	  if [ $i -eq 30 ]; then
		echo "ERROR: Mount failed to become ready within 30 seconds"
		exit 1
	  fi
	  sleep 1
	done

	# sorting process
	echo "Starting media sort..."
	${media-sort}/bin/media-sort \
	  --action copy \
	  --concurrency 1 \
	  --accuracy-threshold 90 \
	  --tv-dir "$destination_tvshows" \
	  --movie-dir "$destination_movies" \
	  --tv-template "$template_tvshows" \
	  --movie-template "$template_movies" \
	  --recursive \
	  --overwrite-if-larger \
	  --extensions "mp4,m4v,mkv" \
	  "$temp_mount"

	echo "Media sort completed successfully"
  '';
in {
  environment.systemPackages = [tank-sort media-sort];
}
