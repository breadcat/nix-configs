{ pkgs, ... }:

{
  environment.systemPackages = [
    (pkgs.writeShellScriptBin "duplicate-filenames" ''
      set -euo pipefail

      usage() {
        echo "Usage: $0 [-r] <dir1> <dir2> [dir3 ...]"
        echo "  -r    Search recursively"
        exit 1
      }

      recursive=false

      while getopts ":r" opt; do
        case "$opt" in
          r) recursive=true ;;
          *) usage ;;
        esac
      done
      shift $((OPTIND - 1))

      [[ $# -ge 2 ]] || usage

      for dir in "$@"; do
        [[ -d "$dir" ]] || {
          echo "Not a directory: $dir"
          exit 1
        }
      done

      run_find() {
        local dir=$1
        if $recursive; then
          find "$dir" -type f -print0
        else
          find "$dir" -maxdepth 1 -type f -print0
        fi
      }

      declare -A files

      for dir in "$@"; do
        while IFS= read -r -d "" file; do
          base=''${file##*/}

          files["$base"]+="$file
"
        done < <(run_find "$dir")
      done

      for base in "''${!files[@]}"; do
        matches=''${files["$base"]}

        count=0
        while IFS= read -r match; do
          [[ -n "$match" ]] && ((count += 1))
        done <<< "$matches"

        (( count > 1 )) || continue

        printf "MATCH: %s\n" "$base"

        while IFS= read -r match; do
          [[ -n "$match" ]] || continue
          printf "  %s\n" "$match"
        done <<< "$matches"

        printf "\n"
      done
    '')
  ];
}
