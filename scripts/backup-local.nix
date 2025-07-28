{
  pkgs,
  domain,
  ...
}: let
  backup-local = pkgs.writeShellScriptBin "backup-local" ''
    # variables
    mount_points=("/mnt/" "/usb/")
    report_file=("''${mount_points[1]}reports/$(date +"%Y-%m-%d_%H-%M").log")
    # checks
    for dir in "''${mount_points[@]}"; do
      if ! findmnt -r "$dir" > /dev/null; then
        echo "Error: $dir is not mounted. Exiting." >&2
        exit 1
      fi
    done
    if [ ! -w "''${mount_points[1]}" ]; then
      echo "Error: No write permissions for destination. Exiting." >&2
      exit 1
    fi
    printf "Mirroring from %s to %s.\n" "''${mount_points[0]}" "''${mount_points[1]}"
    read -n1 -r -p "Press any key to begin..." key
    # process
    mkdir -p "$(dirname "$report_file")"
    rsync -avhP --delete --exclude=lost+found/ --exclude=reports/ "''${mount_points[0]}" "''${mount_points[1]}" 2>&1 | tee "$report_file"
  '';
in {
  environment.systemPackages = [backup-local];
}
