{pkgs, ...}: let
  ctimerename = pkgs.writeShellScriptBin "ctimerename" ''
    extension="$1"
    if [ -z "$extension" ]; then
      echo "Extension variable is empty. Please specify a extension, e.g. jpg"
      exit 1
    fi
    for file in *."$extension"; do
      if [ -f "$file" ]; then
      timestamp=$(stat -c %y "$file" | cut -d'.' -f1 | sed 's/[: ]/-/g')
      newname="''${timestamp}.$extension"

      # If the filename exists, add a counter
      count=1
      while [ -e "$newname" ]; do
        newname="''${timestamp}_$count.$extension"
        ((count++))
      done

      echo "Renaming '$file' to '$newname'"
      mv "$file" "$newname"
      fi
    done
  '';
in {
  environment.systemPackages = [ctimerename];
}
