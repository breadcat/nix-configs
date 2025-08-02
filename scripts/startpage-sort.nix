{pkgs, ...}: let
  startpage-sort = pkgs.writeShellScriptBin "startpage-sort" ''
	set -euo pipefail

	source_file="$HOME/vault/src/startpage/index.html"
	backup="''${source_file}.bak"

	cp "$source_file" "$backup"

	awk '
	function ci_cmp(i1, v1, i2, v2,    a, b) {
	  a = tolower(v1)
	  b = tolower(v2)
	  return (a < b ? -1 : a > b ? 1 : 0)
	}

	BEGIN {
	  PROCINFO["sorted_in"] = "ci_cmp"
	  in_bm = 0
	  in_cm = 0
	  nb = 0
	  nc = 0
	}

	# Start of bookmarks block
	/^      const bookmarks = \[$/ {
	  in_bm = 1
	  print
	  next
	}

	# End of bookmarks block
	in_bm && /^\s+\];$/ {
	  for (i in bookmarks) print bookmarks[i]
	  print
	  in_bm = 0
	  delete bookmarks
	  next
	}

	# Inside bookmarks block
	in_bm {
	  bookmarks[$0] = $0
	  next
	}

	# Start of commandMap block
	/^      const commandMap = {$/ {
	  in_cm = 1
	  print
	  next
	}

	# End of commandMap block
	in_cm && /^\s+\};$/ {
	  for (i in commands) print commands[i]
	  print
	  in_cm = 0
	  delete commands
	  next
	}

	# Inside commandMap block
	in_cm {
	  commands[$0] = $0
	  next
	}

	# Default
	{
	  print
	}
	' "$backup" > "$source_file"
  '';
in {
  environment.systemPackages = [startpage-sort];
}
