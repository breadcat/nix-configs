{pkgs, ...}: let
  phone-dump = pkgs.writeShellScriptBin "phone-dump" ''
    # variables
    phone_remote=phone
    destination="/tank/pictures/personal"
    if [ ! -d "$destination" ]; then
      echo "Destination $destination does not exist."
      exit 1
    fi

    # if ping phone
    if ping -c 1 "$phone_remote" &>/dev/null; then
      echo "Phone reachable, mounting remote"
      directory_temp="$(mktemp -d)"
      ${pkgs.rclone}/bin/rclone mount "$phone_remote": "$directory_temp" --daemon
      cd "$directory_temp" || exit

    declare -a directories=(
      "$directory_temp/DCIM/Camera"
      "$directory_temp/Pictures"
      "$directory_temp/Pictures/Whatsapp"
      "$directory_temp/Android/media/com.whatsapp/WhatsApp/Media"
      "$directory_temp/Android/media/com.whatsapp/WhatsApp/Media/WhatsApp Images"
      "$directory_temp/Android/media/com.whatsapp/WhatsApp/Media/WhatsApp Video"
      )
    for i in "''${directories[@]}"
    do
      if [ -d "$i" ]; then
        echo "$i"
        find "$i" -type f -name '.nomedia*' -delete -print
        ${pkgs.phockup}/bin/phockup "$i" "$destination/" -m
      fi
    done

      if [ -d "$directory_temp/Pictures/Screenshots" ]; then
        find "$directory_temp/Pictures/Screenshots" -type f -exec mv '{}' "$destination/screenshots/" -vi \;
      fi

      echo "Tidying up..."
      find "$destination" -type f -iname 'thumbs.db' -delete -print
      find "$destination" -type f -name '.nomedia*' -delete -print
      find "$destination" -type d -name '.thumbnails*' -delete -print
      find "$directory_temp" -maxdepth 2 -type d -not -path "*/\.*" -empty -delete -print 2>/dev/null
      echo "Unmounting storage..."
      sleep 2s
      umount "$directory_temp" || fusermount -uz "$directory_temp"
      echo "Deduplicating photos..."
      ${pkgs.jdupes}/bin/jdupes "$destination" -r
      find "/tmp/tmp.*" -maxdepth 1 -type d -not -path "*/\.*" -empty -delete -print 2>/dev/null
    else
      echo "Phone not reachable via ping, exiting" && exit 1
    fi
  '';
in {
  environment.systemPackages = [phone-dump];
}
