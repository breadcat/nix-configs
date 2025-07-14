{pkgs, ...}: let
  duupmove = pkgs.writeShellScriptBin "duupmove" ''

    target_dir="$1"

      if [ -z "$target_dir" ]; then
        echo "Target directory variable is empty. Please specify a directory, e.g. /mnt/destination/"
        exit 1
      fi

    mkdir -p "$target_dir"

    # Pictures
    for file in *.jpg; do
        if [[ "$file" =~ ^[0-9]+_[0-9a-f]{32}\.jpg$ ]]; then
            mv "$file" "$target_dir/" -vin
        fi
        if [[ "$file" =~ ^[0-9]{9}_[A-Za-z0-9]{10}\.jpg$ ]]; then
            mv "$file" "$target_dir/" -vin
        fi
    done

    # Videos
    for file in *.mp4; do
        if [[ "$file" =~ ^[0-9a-f]{8}-[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\.mp4$ ]]; then
            mv "$file" "$target_dir/" -vin
        fi
    done

    jdupes "$target_dir" "." -d
  '';
in {
  environment.systemPackages = [duupmove];
}
