{ pkgs, ... }:

{
  environment.systemPackages = [
    (pkgs.writeShellScriptBin "scan-to-pdf" ''
		set -e

		# Default values
		MODE="Gray"
		SOURCE="ADF Front"

		# Parse arguments in any order
		for arg in "$@"; do
		  case "$arg" in
			color)
			  MODE="Color"
			  ;;
			duplex)
			  SOURCE="ADF Duplex"
			  ;;
			*)
			  echo "Unknown argument: $arg"
			  echo "Usage: scan-to-pdf [color] [duplex]"
			  exit 1
			  ;;
		  esac
		done

		# Display scanning mode
		if [ "$MODE" = "Color" ]; then
		  echo "Scanning in color mode"
		else
		  echo "Scanning in greyscale, add 'color' argument to scan in full color"
		fi

		if [ "$SOURCE" = "ADF Duplex" ]; then
		  echo "Scanning both sides (duplex mode)"
		else
		  echo "Scanning single-sided, add 'duplex' argument to scan both sides"
		fi

		OUTPUT="output-$(date +%Y%m%d-%H%M%S).pdf"
		TMPDIR=$(mktemp -d)

		cleanup() {
		  rm -rf "$TMPDIR"
		}
		trap cleanup EXIT

		echo "Scanning pages..."
		if ! ${pkgs.sane-backends}/bin/scanimage --format=tiff --resolution 300 --mode "$MODE" \
		  --batch="$TMPDIR/page%d.tiff" --source "$SOURCE"; then
		  echo "Error: Scanning failed. Is there paper in the ADF?"
		  exit 1
		fi

		if ! ls "$TMPDIR"/*.tiff 1> /dev/null 2>&1; then
		  echo "Error: No pages were scanned."
		  exit 1
		fi

		echo "Converting to PDF..."
		${pkgs.imagemagick}/bin/magick "$TMPDIR"/*.tiff "$TMPDIR/combined.pdf"

		echo "Running OCR..."
		${pkgs.ocrmypdf}/bin/ocrmypdf --deskew --rotate-pages --rotate-pages-threshold 0.5 \
		  --optimize 1 "$TMPDIR/combined.pdf" "$OUTPUT"

		echo "Done! Output saved to: $OUTPUT"
    '')
  ];
}
