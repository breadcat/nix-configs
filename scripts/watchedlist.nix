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
		echo "Database \"$database\" file missing, exiting"
		exit 0
	fi

	# count watched content
	movie_count=$(sqlite3 "$database" "SELECT COUNT(*) FROM movie_watched;")
	episode_count=$(sqlite3 "$database" "SELECT COUNT(*) FROM episode_watched;")

	# blank database
	if [ "$movie_count" -eq 0 ] && [ "$episode_count" -eq 0 ]
	then
		echo "Warning: blank database detected."
		echo "No watched movies or TV episodes were found in \"$database\"."
		printf "Do you want to delete this database? [y/N] "
		read -r answer

		case "$answer" in
			[yY]|[yY][eE][sS])
				rm "$database"
				echo "Database \"$database\" deleted."
				;;
			*)
				echo "Database retained."
				;;
		esac

		exit 0
	fi

	# movies
	if [ "$movie_count" -gt 0 ]
	then
		sqlite3 -noheader -quote "$database" "SELECT title FROM movie_watched;" |
			sed "s/^'//;s/'$//" |
			sed 's/^/* /' > movies.md

		echo "Created movies.md ($movie_count movies)"
	fi

	# tv shows
	if [ "$episode_count" -gt 0 ]
	then
		watched_ids=$(sqlite3 -noheader "$database" "SELECT DISTINCT idShow FROM episode_watched;")

		for id in $watched_ids
		do
			title=$(sqlite3 -noheader -quote "$database" "SELECT title FROM tvshows WHERE idShow = $id;")
			title=''${title//\"/}
			title=''${title//\'/}
			latest_season=$(sqlite3 -noheader "$database" "SELECT MAX(season) FROM episode_watched WHERE idShow = $id;")
			latest_episode=$(sqlite3 -noheader "$database" "SELECT MAX(episode) FROM episode_watched WHERE idShow = $id AND season = $latest_season;")
			echo "* "$title" ("$latest_season"x"$latest_episode")"
		done > tv_shows.md

		echo "Created tv_shows.md ($episode_count episodes)"
	fi
  '';
in {
  environment.systemPackages = [ watchedlist ];
}
