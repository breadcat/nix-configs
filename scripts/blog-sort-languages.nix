{
  pkgs,
  domain,
  ...
}: let
  blog-sort-languages = pkgs.writeShellScriptBin "blog-sort-languages" ''
      # functions
      function lastmod {
        echo -n "Amending lastmod value... "
        mod_timestamp="$(date +%FT%H:%M:00)"
        sed -i "s/lastmod: .*/lastmod: $mod_timestamp/g" "$1"
        echo -e "$i \e[32mdone\e[39m"
      }
    for i in $HOME/vault/src/blog.${domain}/content/languages/*; do
      if [[ "$i" = *index.md ]]; then continue; fi # there's probably a better way of doing this, but I can't figure it out
      echo -n "Processing $(basename "$i")... "
      shasum_original="$(sha512sum "$i" | awk '{print $1}')"
      file_header="$(head -n 8 "$i")"
      file_body="$(tail -n +9 "$i" | sort | uniq -i)"
      {
        printf "%s\n" "$file_header"
        printf "%s" "$file_body"
      } >"$i"
      shasum_modified="$(sha512sum "$i" | awk '{print $1}')"
      if [[ "$shasum_original" != "$shasum_modified" ]]; then
        lastmod "$i" 1>/dev/null
        echo -e "\e[32mmodified\e[39m"
      else
        echo -e "\e[33munmodified\e[39m"
      fi
    done
  '';
in {
  environment.systemPackages = [blog-sort-languages];
}
