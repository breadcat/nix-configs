{ pkgs, ... }:

{
  environment.systemPackages = [
    (pkgs.writeShellScriptBin "duplicate-filenames" ''
      set -euo pipefail

      usage() {
        echo "Usage: $0 [-r] <dir1> <dir2>"
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

      [[ $# -eq 2 ]] || usage

      dir1=$1
      dir2=$2

      [[ -d "$dir1" && -d "$dir2" ]] || {
        echo "Both arguments must be directories."
        exit 1
      }

      run_find() {
        local dir=$1
        if $recursive; then
          find "$dir" -type f -print0
        else
          find "$dir" -maxdepth 1 -type f -print0
        fi
      }

      declare -A files1

      while IFS= read -r -d "" file; do
        base=''${file##*/}
        files1["$base"]+="$file
"
      done < <(run_find "$dir1")

      while IFS= read -r -d "" file; do
        base=''${file##*/}
        matches=''${files1["$base"]:-}
        [[ -n "$matches" ]] || continue

        while IFS= read -r match; do
          [[ -n "$match" ]] || continue
          printf "MATCH:\n  %s\n  %s\n\n" "$match" "$file"
        done <<< "$matches"
      done < <(run_find "$dir2")
    '')
  ];
}
