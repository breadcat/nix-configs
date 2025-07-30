{ pkgs, ... }:

let
  payslips = pkgs.writeShellScriptBin "payslips" ''
    # Default destination directory, or use argument
    destination_default="/mnt/paperwork/personal/workplace/wages"
    destination_dir="''${1:-$destination_default}"

    # Process matching files
    for file in ./*-[0-9][0-9]-[0-9][0-9]-[0-9][0-9][0-9][0-9].pdf; do
        [[ -e "$file" ]] || continue # Skip if no match
        filename=$(basename "$file")
        # Extract the date
        if [[ "$filename" =~ ([0-9]{2})-([0-9]{2})-([0-9]{4})\.pdf$ ]]; then
            day="''${BASH_REMATCH[1]}"
            month="''${BASH_REMATCH[2]}"
            year="''${BASH_REMATCH[3]}"
            new_filename="''${year}-''${month}-''${day}.pdf"
            mv "$file" "$destination_dir/$new_filename"
            echo "Moved: $file to $destination_dir/$new_filename"
        else
            echo "Skipped (no valid date in name): $filename"
        fi
    done
  '';
in {
  environment.systemPackages = [ payslips ];
}
