{ pkgs, ... }:

let
  youtube-id-rss = pkgs.writeShellScriptBin "youtube-id-rss" ''
    if [ "$#" -eq 0 ]
    then
	echo "No URI argument supplied, using clipboard"
	uri="$(wl-paste)"
    else
	uri="$1"
    fi

    uri_id=$(curl --silent "$uri" | tr "\"" "\n" | grep -P '^(?=.*https)(?=.*channel)' | uniq -c | sort -rn | awk 'NR==1{print $2}' )
    base_id="$(echo "$uri_id" | awk -F "/" '{print $5}')"
    printf "https://www.youtube.com/feeds/videos.xml?channel_id=%s\\n" "$base_id"
  '';

in {
  environment.systemPackages = [ youtube-id-rss ];
}
