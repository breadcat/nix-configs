{
  pkgs,
  domain,
  ...
}: let
  audiobook-cleaner = pkgs.writeShellScriptBin "audiobook-cleaner" ''
  # variables
  list_file="$HOME/vault/src/blog.${domain}/content/reading-list.md"
  media_dir="/mnt/media/literature/audiobooks"

  trim() {
    local var="$*"
    var="''${var#"''${var%%[![:space:]]*}"}"
    var="''${var%"''${var##*[![:space:]]}"}"
    echo -n "$var"
  }

  echo "Generating file list from $media_dir ..."
  mapfile -t file_list < <(find "$media_dir" -type f)

  declare -a lc_file_names
  for i in "''${!file_list[@]}"; do
    lc_file_names[$i]=$(basename "''${file_list[$i]}" | tr '[:upper:]' '[:lower:]')
  done

  declare -a matched_files
  declare -a matched_info

  while IFS= read -r line; do
    author=$(cut -d'-' -f1 <<< "$line")
    author=$(trim "$author")

    title=$(cut -d'-' -f2- <<< "$line")
    title=$(trim "$title")

    lauthor=$(echo "$author" | tr '[:upper:]' '[:lower:]')
    ltitle=$(echo "$title" | tr '[:upper:]' '[:lower:]')

    for i in "''${!file_list[@]}"; do
      lfile="''${lc_file_names[$i]}"
      if [[ "$lfile" == *"$lauthor"* && "$lfile" == *"$ltitle"* ]]; then
        matched_files+=("''${file_list[$i]}")
        matched_info+=("$author - $title")
      fi
    done

  done < <(grep -oP '(?<=<li>).*?(?=</li>)' "$list_file")

  total="''${#matched_files[@]}"
  echo "Found $total matching files."

  for i in "''${!matched_files[@]}"; do
    file="''${matched_files[$i]}"
    info="''${matched_info[$i]}"
    index=$((i + 1))
    abridged=$(echo "$file" | awk -F/ '{print $(NF-1) "/" $NF}')

    echo ""
    echo "[$index of $total] Match: $info"
    echo "Delete file? $abridged (y/N)"
    read -r ans </dev/tty
    if [[ "$ans" =~ ^[Yy]$ ]]; then
      rm "$file" && echo "Deleted $abridged"
    else
      echo "Skipped $abridged"
    fi
  done
  '';
in {
  environment.systemPackages = [audiobook-cleaner];
}
