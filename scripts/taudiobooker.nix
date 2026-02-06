{ pkgs, ... }:

{
  environment.systemPackages = [
    (pkgs.writeShellScriptBin "taudiobooker" ''
		set -euo pipefail

		# variables
		codec="libopus"
		bitrate="48k"
		compression="10"
		output=""

		# functions
		strip_chars() { awk '{gsub(/^[ \t-]+|[ \t-]+$/,""); print $0}'; }

		process_opus_file() {
			local file="$1"
			output="$file"

			echo "Tagging OPUS file: $file"

			${pkgs.opustags}/bin/opustags -i -D "$output"
			${pkgs.opustags}/bin/opustags -i -s "GENRE=Audiobook" "$output"

			artist=$(printf "%s" "$output" |
					 awk -F"-" '{print $1}' |
					 strip_chars)

			${pkgs.opustags}/bin/opustags -i -s "ARTIST=$artist" "$output"

			if [[ "$output" == *"#"* ]]; then
				# Series format
				album=$(printf "%s" "$output" |
						awk -F"-" '{print $2}' |
						awk -F"#" '{print $1}' |
						strip_chars)

				track=$(printf "%s" "$output" |
						awk -F"-" '{print $2}' |
						awk -F"#" '{print $2}' |
						awk '{gsub("^0*",""); print}' |
						strip_chars)

				title=$(printf "%s" "$output" |
						awk -F"-" '{gsub(".opus",""); print $3}' |
						strip_chars)

				${pkgs.opustags}/bin/opustags -i -s "ALBUM=$album" "$output"
				${pkgs.opustags}/bin/opustags -i -s "TRACKNUMBER=$track" "$output"
				${pkgs.opustags}/bin/opustags -i -s "TITLE=$title" "$output"

			else
				# Single file
				title=$(printf "%s" "$output" |
						awk -F"-" '{gsub(".opus",""); print $2}' |
						strip_chars)

				${pkgs.opustags}/bin/opustags -i -s "TITLE=$title" "$output"
			fi
		}

		process_other_file() {
			local file="$1"
			local base="''${file%.*}"
			output="''${base}.opus"

			echo "Encoding file to OPUS: $file → $output"

			${pkgs.ffmpeg}/bin/ffmpeg -hide_banner -loglevel error -nostats \
				-i "$file" \
				-acodec "$codec" \
				-ac 1 \
				-b:a "$bitrate" \
				-vbr on \
				-compression_level "$compression" \
				"$output"

			echo "Done: $output"
		}

		analyze_directory() {
			local dir="$1"
			echo "Analyzing and concatenating directory: $dir"

			# Find most common extension
			local extension
			extension=$(find "$dir" -type f -printf '%f\n' \
				| sed -E 's/.*\.([^.]+)$/\1/' \
				| sort | uniq -c | sort -nr | awk 'NR==1{print $2}')

			if [[ -z "''${extension}" ]]; then
				echo "No files found in directory."
				exit 1
			fi

			echo "Most common filetype: .$extension"

			# Output filename based on directory name
			local name
			name=$(basename "$dir")
			output="''${name}.opus"

			echo "Concatenating all .$extension files → $output"

			${pkgs.ffmpeg}/bin/ffmpeg -f concat -safe 0 \
				-i <(for f in "$dir"/*."$extension"; do
						echo "file '$PWD/$f'"
					  done) \
				-acodec "$codec" \
				-ac 1 \
				-b:a "$bitrate" \
				-vbr on \
				-compression_level "$compression" \
				"$output"

			echo "Created: $output"
		}

		# main logic

		if [[ $# -ne 1 ]]; then
			echo "Usage: $0 <file-or-directory>"
			exit 1
		fi

		input="$1"

		if [[ -d "$input" ]]; then
			analyze_directory "$input"
		elif [[ -f "$input" ]]; then
			ext="''${input##*.}"
			shopt -s nocasematch
			if [[ "$ext" == "opus" ]]; then
				process_opus_file "$input"
			else
				process_other_file "$input"
			fi
			shopt -u nocasematch
		else
			echo "Error: '$input' is not a valid file or directory"
			exit 1
		fi
    '')
  ];
}
