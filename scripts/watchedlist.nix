{ pkgs, ... }:

let
  watchedlist = pkgs.writeShellScriptBin "watchedlist" ''
	# variables
	if [ -z "$1" ]
	then
		database="watchedlist.db"
	else
		database="$1"
	fi
	# checks
	if [ ! -f "$database" ]
	then
		echo Database "$database" file missing, exiting
		exit 0
	fi
	# TODO: blank database check
	# movies
	sqlite3 -noheader -quote "$database" "SELECT title FROM movie_watched" | sed "s/^'//;s/'$//" | sed 's/^/* /' > movies.md
	# tv shows
	watched_ids=$(sqlite3 -noheader "$database" "SELECT DISTINCT idShow FROM episode_watched;")
	for id in $watched_ids; do
	  title=$(sqlite3 -noheader -quote "$database" "SELECT title FROM tvshows WHERE idShow = $id;")
	  title=''${title//\"/}
	  title=''${title//\'/}
	  latest_season=$(sqlite3 -noheader "$database" "SELECT MAX(season) FROM episode_watched WHERE idShow = $id;")
	  latest_episode=$(sqlite3 -noheader "$database" "SELECT MAX(episode) FROM episode_watched WHERE idShow = $id AND season = $latest_season;")
	  echo "* "$title" ("$latest_season"x"$latest_episode")"
	done > tv_shows.md
  '';
in {
  environment.systemPackages = [ watchedlist ];
}
