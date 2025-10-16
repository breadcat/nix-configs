{
  pkgs,
  domain,
  ...
}: let
  blog-sort-archives = pkgs.writeShellScriptBin "blog-sort-archives" ''
    # variables
    movies_export="$HOME/vault/src/blog.${domain}/content/posts/archived-movies.md"
    tvshows_export="$HOME/vault/src/blog.${domain}/content/posts/archived-television.md"
    # functions
    function lastmod {
      echo -n "Amending lastmod value... "
      mod_timestamp="$(date +%FT%H:%M:00)"
      sed -i "s/lastmod: .*/lastmod: $mod_timestamp/g" "$1"
      echo -e "$i \e[32mdone\e[39m"
    }
    # process
    movies_shasum_original="$(sha512sum "$movies_export" | awk '{print $1}')"
    movie_header="$(grep -v "^*" "$movies_export")"
    movies_raw="$(grep "^*" "$movies_export")"
    echo -n "Writing movies export... "
    {
      printf "%s\n" "$movie_header"
      printf "%s\n" "$movies_raw" | paste <( printf "%s\n" "$movies_raw" | sed 's/^\* //' | sed -E 's/^(The|A|An) //I' ) - | sort -f | uniq -i | cut -f2
    } >"$movies_export"
    movies_shasum_modified="$(sha512sum "$movies_export" | awk '{print $1}')"
	if [[ "$movies_shasum_original" != "$movies_shasum_modified" ]]; then
		lastmod "$movies_export" 1>/dev/null
		echo -e "\e[32mmodified\e[39m"
	else
		echo -e "\e[33munmodified\e[39m"
	fi
    # tv shows
    tvshows_shasum_original="$(sha512sum "$tvshows_export" | awk '{print $1}')"
    tvshows_header="$(grep -v "^*" "$tvshows_export")"
    tvshows_raw="$(grep "^*" "$tvshows_export")"
    echo -n "Writing TV shows export... "
    {
      printf "%s\n" "$tvshows_header"
      printf "%s\n" "$tvshows_raw" | paste <( printf "%s\n" "$tvshows_raw" | sed 's/^\* //' | sed -E 's/^(The|A|An) //I' ) - | sort -f | uniq -i | cut -f2
    } >"$tvshows_export"
    tvshows_shasum_modified="$(sha512sum "$tvshows_export" | awk '{print $1}')"
	if [[ "$tvshows_shasum_original" != "$tvshows_shasum_modified" ]]; then
		lastmod "$tvshows_export" 1>/dev/null
		echo -e "\e[32mmodified\e[39m"
	else
		echo -e "\e[33munmodified\e[39m"
	fi
  '';
in {
  environment.systemPackages = [blog-sort-archives];
}
