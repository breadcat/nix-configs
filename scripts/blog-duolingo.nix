{ pkgs, vars, ... }:

let
  blog-duolingo = pkgs.writeShellScriptBin "blog-duolingo" ''
    # variables
    username="$(awk -F'[/()]' '/Duolingo/ {print $5}' "$HOME/vault/src/blog.${vars.user.domain}/content/about.md")"
	post_file="$HOME/vault/src/blog.${vars.user.domain}/content/posts/logging-duolingo-ranks-over-time.md"
	# functions
    function lastmod {
      echo -n "Amending lastmod value... "
      mod_timestamp="$(date +%FT%H:%M:00)"
      sed -i "s/lastmod: .*/lastmod: $mod_timestamp/g" "$1"
      echo -e "$i \e[32mdone\e[39m"
    }
	# process
	page_source="$(curl -s https://duome.eu/"$username")"
	rank_lingot="$(printf %s "$page_source" | awk -F"[#><]" '/icon lingot/ {print $15}')"
	rank_streak="$(printf %s "$page_source" | awk -F"[#><]" '/icon streak/{getline;print $15}')"
	# write
	echo -e "$i \e[32mdone\e[39m"
	echo -n "Appending ranks to page... "
	sed -i '/<\/tbody><\/table>/d' "$post_file"
	printf "  <tr><td>%s</td><td>%s</td><td>%s</td><td>%s</td></tr>\n</tbody></table>" "$(date +%F)" "$(date +%H:%M)" "$rank_streak" "$rank_lingot" >>"$post_file"
	echo -e "$i \e[32mdone\e[39m"
	lastmod "$post_file"
  '';
in {
  environment.systemPackages = [ blog-duolingo ];

  systemd.services.blog-duolingo = {
    description = "Fetch and log Duolingo ranks to blog";
    serviceConfig = {
      Type = "oneshot";
      User = vars.user.username;
      ExecStart = "${blog-duolingo}/bin/blog-duolingo";
      Environment = "PATH=/run/current-system/sw/bin:/run/wrappers/bin";
    };
  };

  systemd.timers.blog-duolingo = {
    description = "Run blog-duolingo every Sunday at 23:55";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "Sun *-*-* 23:55:00";
      Persistent = true;
    };
  };
}
