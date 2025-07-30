{
  pkgs,
  domain,
  ...
}: let
  blog-music = pkgs.writeShellScriptBin "blog-music" ''
    # variables
	post="$HOME/vault/src/blog.${domain}/content/music.md"
	header="$(grep -v \| "$post")"
	# functions
    function lastmod {
      echo -n "Amending lastmod value... "
      mod_timestamp="$(date +%FT%H:%M:00)"
      sed -i "s/lastmod: .*/lastmod: $mod_timestamp/g" "$1"
      echo -e "$i \e[32mdone\e[39m"
    }
	echo -n "Checking for $(basename "$post")..."
	if test -f "$post"; then
		echo -e "$i \e[32mexists\e[39m"
	else
		echo -e "$i \e[31mdoes not exist\e[39m. Exiting"
		exit 1
	fi
	source=liked.csv
	echo -n "Checking for $source..."
	if test -f "$source"; then
		echo -e "$i \e[32mexists\e[39m"
	else
		echo -e "$i \e[31mdoes not exist\e[39m. Exiting"
		exit 1
	fi
	echo -n "Processing $source... "
	tail -n +2 <"$source" |
		awk -F'\",\"' '{print $4}' |
		sed 's/\\\,/,/g' >temp.artists.log
	tail -n +2 <"$source" |
		awk -F'\",\"' '{print $2}' |
		sed 's/ - .... - Remaster$//g' |
		sed 's/ - .... Remaster$//g' |
		sed 's/ - .... Remastered Edition$//g' |
		sed 's/ - .... re-mastered version$//g' |
		sed 's/ - .... Remastered Version$//g' |
		sed 's/ - feat.*$//g' |
		sed 's/ - Live$//g' |
		sed 's/ - Original Mix$//g' |
		sed 's/ - Remaster$//g' |
		sed 's/ - Remastered ....$//g' |
		sed 's/ - Remastered$//g' |
		sed 's/ - Remastered Version$//g' |
		sed 's/ (.... Remaster)$//g' |
		sed 's/ (feat.*)$//g' |
		sed 's/ (Live)//g' |
		sed 's/\[[^][]*\]//g' |
		awk '{print "["$0"]"}' >temp.tracks.log
	tail -n +2 <"$source" |
		awk -F'\"' '{print $2}' |
		awk '{print "("$0")"}' >temp.links.log
	echo -e "\e[32mdone\e[39m"
	# write page
	echo -n "Writing page... "
	{
		printf "%s\n\n" "$header"
		printf "%s" "$(paste temp.artists.log temp.tracks.log temp.links.log | sed 's/\t/ \| /g' | sed 's/^/\| /g' | sed 's/$/ \|/g' | sed 's/\] | (/\](/g')" | sort | uniq -i | sed -e '1i\| ------ \| ----- \|' | sed -e '1i\| Artist \| Title \|'
	} >"$post"
	echo -e "\e[32mdone\e[39m"
	lastmod "$post"
	echo -n "Deleting temporary files... "
	rm temp.{artists,tracks,links}.log
	echo -e "\e[32mdone\e[39m"
	
  '';
in {
  environment.systemPackages = [blog-music];
}
