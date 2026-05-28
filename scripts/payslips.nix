{ pkgs, vars, ... }:

let
  payslips = pkgs.writeShellScriptBin "payslips" ''
    destination_default="/tank/paperwork/personal/workplace/wages"
    destination_dir="''${1:-$destination_default}"

    mkdir -p "$destination_dir"

    shopt -s nullglob

    for file in ./*.PDF; do
        filename=$(basename "$file")

        # Match: "10 - 31052026.PDF"
        if [[ "$filename" =~ ^[0-9]+[[:space:]]-[[:space:]]([0-9]{2})([0-9]{2})([0-9]{4})\.PDF$ ]]; then
            day="''${BASH_REMATCH[1]}"
            month="''${BASH_REMATCH[2]}"
            year="''${BASH_REMATCH[3]}"

            new_filename="''${year}-''${month}-''${day}.pdf"
            output_path="$destination_dir/$new_filename"

            # Avoid overwriting existing files
            if [[ -e "$output_path" ]]; then
                output_path="$destination_dir/''${year}-''${month}-''${day}-$(date +%s).pdf"
            fi

            # Remove PDF password protection
            ${pkgs.qpdf}/bin/qpdf --password=${vars.secrets.pdfpassword} --decrypt "$file" "$output_path"

            if [[ $? -eq 0 ]]; then
                rm "$file"
                echo "Processed: $file -> $output_path"
            else
                echo "Failed to process: $file"
            fi
        else
            echo "Skipped (filename did not match expected format): $filename"
        fi
    done
  '';
in {
  environment.systemPackages = [ payslips ];
}
