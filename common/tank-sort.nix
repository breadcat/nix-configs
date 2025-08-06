{ pkgs, username, ... }:

let
  tank-sort = pkgs.writeShellScriptBin "tank-sort" ''
	# variables
	temp_mount="$(mktemp -d)"
	rclone_remote="seedbox:"
	destination_tvshows="/tank/media/videos/television"
	template_tvshows="{{ .Name }}/{{ .Name }} S{{ printf \"%02d\" .Season }}E{{ printf \"%02d\" .Episode }}{{ if ne .ExtraEpisode -1 }}-{{ printf \"%02d\" .ExtraEpisode }}{{end}}.{{ .Ext }}"
	destination_movies="/tank/media/videos/movies"
	template_movies="{{ .Name }} ({{ .Year }})/{{ .Name }}.{{ .Ext }}"
	# mount remote
	${pkgs.rclone}/bin/rclone mount "$rclone_remote" "$temp_mount" --daemon
	# sorting process
	media-sort --action copy --concurrency 1 --accuracy-threshold 90 --tv-dir "$destination_tvshows" --movie-dir "$destination_movies" --tv-template "$template_tvshows" --movie-template "$template_movies" --recursive --overwrite-if-larger --extensions "mp4,m4v,mkv" "$temp_mount"
	# unmount remote and remove
	fusermount -uz "$temp_mount" 2>/dev/null
	find "$temp_mount" -maxdepth 1 -mount -type d -empty -delete -print
  '';
in {
  environment.systemPackages = [tank-sort];

  systemd.timers.tank-sort = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "0/12:00:00";
      RandomizedDelaySec = "5min";
      Persistent = true;
    };
  };

  systemd.services.tank-sort = {
    script = "tank-sort";
    path = [ "/run/current-system/sw" ];
    serviceConfig = {
      Type = "oneshot";
      User = "${username}";
    };
  };
}
