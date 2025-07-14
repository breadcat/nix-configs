{
  pkgs,
  domain,
  ...
}: let
  blog-sort-quotes = pkgs.writeShellScriptBin "blog-sort-quotes" ''
    # variables
	quote_file="$HOME/vault/src/blog.${domain}/content/quotes.md"
	file_header="$(head -n 7 "$quote_file")"
	file_body="$(tail -n +7 "$quote_file" | sort | uniq -i | sed G)"
	# functions
    function lastmod {
      echo -n "Amending lastmod value... "
      mod_timestamp="$(date +%FT%H:%M:00)"
      sed -i "s/lastmod: .*/lastmod: $mod_timestamp/g" "$1"
      echo -e "$i \e[32mdone\e[39m"
    }
	echo -n "Processing $(basename "$quote_file")... "
	shasum_original="$(sha512sum "$quote_file" | awk '{print $1}')"
	{
		printf "%s\n" "$file_header"
		printf "%s" "$file_body"
	} >"$quote_file"
	shasum_modified="$(sha512sum "$quote_file" | awk '{print $1}')"
	if [[ "$shasum_original" != "$shasum_modified" ]]; then
		lastmod "$i" 1>/dev/null
		echo -e "\e[32mmodified\e[39m"
	else
		echo -e "\e[33munmodified\e[39m"
	fi
  '';
in {
  environment.systemPackages = [blog-sort-quotes];
}
