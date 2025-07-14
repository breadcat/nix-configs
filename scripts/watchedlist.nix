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
	if [ -f "movies.csv" ]; then rm movies.csv; fi
	sqlite3 -noheader -csv $database "select title from movie_watched;" > movies.csv
	sed -i -e 's|\"||g' -e 's|^|* |g' movies.csv
	sort -k 2 < movies.csv > movies.md
	rm movies.csv
	# tv shows
	sqlite3 -noheader -csv $database "select * from tvshows;" > tv_shows_index.csv
	watched_id=$(sqlite3 -noheader $database "select idShow from episode_watched;" | uniq)
	for i in $watched_id; do grep "$i" tv_shows_index.csv | cut -f2- -d, >> tv_shows.csv; done
	sed -i -e 's|\"||g' -e 's|^|* |g' tv_shows.csv
	sort -k 2 < tv_shows.csv > tv_shows.md
	rm tv_shows.csv tv_shows_index.csv
  '';

in {
  environment.systemPackages = [ watchedlist ];
}
