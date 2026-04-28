{ pkgs, ... }:

let
  payslips = pkgs.writeShellScriptBin "payslips" ''
    # Default destination directory, or use argument
    destination_default="/tank/paperwork/personal/workplace/wages"
    destination_dir="''${1:-$destination_default}"
    pdftotext_bin="${pkgs.poppler-utils}/bin/pdftotext"

    # Process matching files
    for file in ./????????-????-????-????-????????????-result.pdf; do
        [[ -e "$file" ]] || continue # Skip if no match
        filename=$(basename "$file")
        # Extract the date
        date=$("$pdftotext_bin" "$file" - | grep -oE '[0-9]{2}-[0-9]{2}-[0-9]{4}' | head -n1)
        if [[ "$date" =~ ^([0-9]{2})-([0-9]{2})-([0-9]{4})$ ]]; then
            day="''${BASH_REMATCH[1]}"
            month="''${BASH_REMATCH[2]}"
            year="''${BASH_REMATCH[3]}"
            new_filename="''${year}-''${month}-''${day}.pdf"

            # Avoid overwriting existing files
            if [[ -e "$destination_dir/$new_filename" ]]; then
                new_filename="''${year}-''${month}-''${day}-$(date +%s).pdf"
            fi

            mv "$file" "$destination_dir/$new_filename"
            echo "Moved: $file to $destination_dir/$new_filename"
        else
            echo "Skipped (no valid date found in PDF): $filename"
        fi
    done
  '';
in {
  environment.systemPackages = [ payslips ];
}
