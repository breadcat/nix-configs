{pkgs, ...}:

let
  pbx = pkgs.writeShellScriptBin "pbx" ''

set -euo pipefail

usage() {
local prog=''${0##*/}
cat <<EOF
Usage:
  $prog <model> <input> [output] [--volume N]

Examples:
  $prog samsung greeting.mp3
  $prog samsung greeting.mp3 output.wav
  $prog gamma prompt.flac --volume 0.8
  $prog webex prompt.wav output.wav --volume 0.75
EOF
exit 1
}

VOLUME=""
POSITIONAL=()

while [[ $# -gt 0 ]]; do
	case "$1" in
		--volume)
			[[ $# -ge 2 ]] || {
				echo "--volume requires a value"
				exit 1
			}
			VOLUME="$2"
			shift 2
			;;
		-h|--help)
			usage
			;;
		*)
			POSITIONAL+=("$1")
			shift
			;;
	esac
done

set -- "''${POSITIONAL[@]}"

[[ $# -ge 2 && $# -le 3 ]] || usage

MODEL=$(tr '[:upper:]' '[:lower:]' <<<"$1")
INPUT="$2"

if [[ $# -eq 3 ]]; then
	OUTPUT="''${3%.*}.wav"
else
	OUTPUT="''${INPUT%.*}.wav"
fi

[[ -f "$INPUT" ]] || {
	echo "Input file not found."
	exit 1
}

case "$MODEL" in
	samsung|3cx|webex) CODEC_ARGS=(-codec:a pcm_s16le -ab 128k) ;;
	lg-emg|lg-ucp|panasonic|gamma) CODEC_ARGS=(-codec:a pcm_mulaw -ab 64k) ;;
	lg-hosted) CODEC_ARGS=(-codec:a pcm_s16le -ab 64k) ;;
	*) echo "Unknown model '$MODEL'" && exit 1 ;;
esac

FFMPEG_ARGS=()

if [[ -n "$VOLUME" ]]; then
	FFMPEG_ARGS+=(-af "volume=$VOLUME")
fi

# Avoid overwriting the input if converting an existing WAV.
if [[ "$(realpath "$INPUT")" == "$(realpath -m "$OUTPUT")" ]]; then
	BACKUP="''${INPUT%.wav}.original.wav"

	if [[ -e "$BACKUP" ]]; then
		i=1
		while [[ -e "''${INPUT%.wav}.original.''${i}.wav" ]]; do
			((i++))
		done
		BACKUP="''${INPUT%.wav}.original.''${i}.wav"
	fi

	mv "$INPUT" "$BACKUP"
	INPUT="$BACKUP"

	echo "Original renamed to $BACKUP"
fi

${pkgs.ffmpeg}/bin/ffmpeg -i "$INPUT" -ar 8000 -ac 1 "''${CODEC_ARGS[@]}" "''${FFMPEG_ARGS[@]}" "$OUTPUT"

echo "Created $OUTPUT"

  '';
in {
  environment.systemPackages = [pbx];
}
