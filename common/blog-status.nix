{ pkgs, username, domain, ... }:

let
  blog-status = pkgs.writeShellScriptBin "blog-status" ''
    # variables
	status_uptime=$(($(cut -f1 -d. </proc/uptime) / 86400))
	# process
	{
		printf -- "---\\ntitle: Status\\nlayout: single\\n---\\n\\n"
		printf "*Generated on %(%Y-%m-%d at %H:%M)T*\\n\\n" -1
		printf "* Uptime: %s Day%s\\n" "$status_uptime" "$(if (("$status_uptime" > 1)); then echo s; fi)"
		printf "* CPU Load: %s\\n" "$(cut -d" " -f1-3 </proc/loadavg)"
		printf "* Users: %s\\n" "$(who | wc -l)"
		printf "* RAM Usage: %s%%\\n" "$(printf "%.2f" "$(free | awk '/Mem/ {print $3/$2 * 100.0}')")"
		printf "* Root Storage: %s\\n" "$(df / | awk 'END{print $5}')"
		# TODO printf "* Tank Storage: %s\\n" "$(df | awk -v tank="$directory_tank" '$0 ~ tank {print $5}')"
		# TODO printf "* Torrent Ratio: %s\\n" "$(echo "scale=3; $(awk '/uploaded/ {print $2}' "$(find_directory docker)"/transmission/stats.json)" / "$(awk '/downloaded/ {print $2}' "$(find_directory docker)"/transmission/stats.json | sed 's/,//g')" | bc)"
		printf "* NAS Storage: %s\\n" "$(git --git-dir="$HOME/vault/src/logger/.git" show | awk 'END{print $3" "$4}')"
		printf "* [Containers](https://github.com/breadcat/Dockerfiles): %s\\n" "$(docker ps -q | wc -l)/$(docker ps -aq | wc -l)"
		# TODO printf "* Packages: %s\\n" "$(pacman -Q | wc -l)"
		printf "* Monthly Data: %s\\n" "$(vnstat -m --oneline | cut -f11 -d\;)"
		printf "\\nHardware specifications themselves are covered on the [hardware page](/hardware/#server).\\n"
	} >"$HOME/vault/src/blog.${domain}/content/status.md"
  '';
in {
  environment.systemPackages = [blog-status];

  systemd.timers.blog-status = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "*:0/10";
      Persistent = true;
    };
  };
  systemd.services.blog-status = {
    script = "blog-status";
    path = [ "/run/current-system/sw" ];
    serviceConfig = {
      Type = "oneshot";
      User = "${username}";
    };
  };
}
