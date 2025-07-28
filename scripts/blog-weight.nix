{
  pkgs,
  domain,
  ...
}: let
  blog-weight = pkgs.writeShellScriptBin "blog-weight" ''
    # variables
	weight_filename="$HOME/vault/src/blog.${domain}/content/weight.md"
	if [ "$1" = "date" ]; then
		printf "Writing empty dates... "
		page_source="$(head -n -1 "$weight_filename")"
		previous_date="$(printf %s "$page_source" | awk -F, 'END{print $1}')"
		sequence_count="$((($(date --date="$(date +%F)" +%s) - $(date --date="$previous_date" +%s)) / (60 * 60 * 24)))"
		{
			printf "%s\\n" "$page_source"
			printf "%s" "$(for i in $(seq $sequence_count); do printf "%s,\\n" "$(date -d "$previous_date+$i day" +%F)"; done)"
			printf "\\n</pre></details>"
		} >"$weight_filename"
		printf "done\\n"
		exit 0
	fi
	printf "Drawing graph... "
	weight_rawdata="$(awk '/<pre>/{flag=1; next} /<\/pre>/{flag=0} flag' "$weight_filename" | sort -u)"
	weight_dateinit="$(awk '/date:/ {print $2}' "$weight_filename")"
	grep "^$(date +%Y)-" <<<"$weight_rawdata" >temp.dat
	${pkgs.gnuplot}/bin/gnuplot <<-EOF
		set grid
		set datafile separator comma
		set xlabel "Month"
		set xdata time
		set timefmt "%Y-%m-%d"
		set xtics format "%b"
		set ylabel "Weight (kg)"
		set key off
		set term svg font 'sans-serif,12'
		set sample 50
		set output "temp.svg"
		plot "temp.dat" using 1:2 smooth cspline with lines
	EOF
	printf "done\\nWriting page... "
	{
		printf -- "---\\ntitle: Weight\\nlayout: single\\ndate: %s\\nlastmod: %(%Y-%m-%dT%H:%M:00)T\\n---\\n\\n" "$weight_dateinit" -1
		printf "%s\\n\\n" "$(${pkgs.scour}/bin/scour -i temp.svg --strip-xml-prolog --remove-descriptive-elements --create-groups --enable-id-stripping --enable-comment-stripping --shorten-ids --no-line-breaks)"
		printf "<details><summary>Raw data</summary>\\n<pre>\\n%s\\n</pre></details>" "$weight_rawdata"

	} >"$weight_filename"
	printf "done\\nCleaning up... "
	rm temp.{dat,svg}
	printf "done\\n"

  '';
in {
  environment.systemPackages = [blog-weight];
}
