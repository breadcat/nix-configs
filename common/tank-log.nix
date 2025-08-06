{ pkgs, username, ... }:

let
  tank-log = pkgs.writeShellScriptBin "tank-log" ''
	# variables
	git_directory="$HOME/vault/src/logger/"
	file_git_log="$git_directory/media.log"
	log_remote="nas:"
	git_logger="git --git-dir=$git_directory/.git --work-tree=$git_directory"
	# git configuruation
	if [ ! -e "$git_directory" ]; then
		printf "Logger directory not found, quitting...\n"
		exit 1
	fi
	if [ ! -e "$git_directory/.git" ]; then
		printf "Initialising blank git repo...\n"
		$git_logger init
	fi
	if [ -e "$file_git_log.xz" ]; then
		printf "Decompressing existing xz archive...\n"
		xz -d "$file_git_log.xz"
	fi
	if [ -e "$file_git_log" ]; then
		printf "Removing existing log file...\n"
		rm "$file_git_log"
	fi
	printf "Creating log...\n"
	${pkgs.rclone}/bin/rclone ls "$log_remote" | sort -k2 >"$file_git_log"
	printf "Appending size information...\n"
	${pkgs.rclone}/bin/rclone size "$log_remote" >>"$file_git_log"
	printf "Commiting log file to repository...\n"
	$git_logger add "$file_git_log"
	$git_logger commit -m "Update: $(date +%F)"
	if [ -e "$file_git_log.xz" ]; then
		printf "Removing xz archive...\n"
		rm "$file_git_log.xz"
	fi
	printf "Compressing log file...\n"
	xz "$file_git_log"
	printf "Compressing repository...\n"
	$git_logger config pack.windowMemory 10m
	$git_logger config pack.packSizeLimit 20m
	$git_logger gc --aggressive --prune
	printf "Log complete!\n"
  '';
in {
  environment.systemPackages = [tank-log];

  systemd.timers.tank-log = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = [ "0/12:20:00" ];
      RandomizedDelaySec = "10min";
      Persistent = true;
    };
  };

  systemd.services.tank-log = {
    script = "tank-log";
    path = [ "/run/current-system/sw" ];
    serviceConfig = {
      Type = "oneshot";
      User = "${username}";
    };
  };
}
