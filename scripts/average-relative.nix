{ pkgs, ... }:

let
  average-relative = pkgs.writeShellScriptBin "average-relative" ''
    dir="''${1:-.}"
    if [[ ! -d "$dir" ]]; then
    echo "Not a directory: $dir" >&2
    exit 1
    fi
    shopt -s nullglob
    for i in "$dir"/*/; do
    i="''${i%/}"
    size=$(du -sk "$i" | awk '{print $1}')
    count=$(find "$i" -type f -size +1M | wc -l)
    (( count == 0 )) && continue
    echo "$((size / count)) $count $size ''${i##*/}"
    done | sort -nr | numfmt -d ' ' --field=1,3 --from-unit=1024 --to=iec --suffix=B |
    while read -r avg count total name; do
    printf '%8s %7s %8s  %s\n' "$avg" "$count" "$total" "$name"
    done
    '';
in
{
  environment.systemPackages = [ average-relative ];
}
