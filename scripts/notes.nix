{ pkgs, ...}: let
  notes = pkgs.writeShellScriptBin "notes" ''

    notes_dir="$SYNCDIR/notes"
    export notes_dir
    commit_msg="Commit $(date +"%Y-%m-%dT%H:%M")"

    # Pull latest from git
    git -C "$notes_dir" pull >/dev/null &
    pull_pid=$!

    # Sync without editing a file
    if [ "$1" = "sync" ]; then
      # Wait for the pull to finish before modifying/committing anything.
      if ! wait "$pull_pid"; then
        echo "Git pull failed."
        exit 1
      fi

      # Delete empty notes files
      find "$notes_dir" -type f -not -path '*/.git/*' -empty -print -delete

      # Commit anything new
      git -C "$notes_dir" add -A
      if git -C "$notes_dir" diff --cached --quiet; then
        echo "No changes made; nothing to commit."
      else
        git -C "$notes_dir" commit -m "$commit_msg" || exit 1
      fi

      # Push everything
      git -C "$notes_dir" push
      exit $?
    fi

    # Interactive file selection
    if ! edit_file=$(
      git -C "$notes_dir" ls-files |
        SHELL="$(command -v bash)" fzf --preview '
          if file --mime-type --brief -- "$notes_dir"/{} | grep -q "^text/"; then
            cat -- "$notes_dir"/{}
          else
            echo "Binary file"
          fi
        ' \
        --preview-window='right:60%:wrap'
    ); then
      kill "$pull_pid" 2>/dev/null
      wait "$pull_pid" 2>/dev/null
      exit 0
    fi

    # Wait for the pull before editing/committing.
    if ! wait "$pull_pid"; then
      echo "Git pull failed."
      exit 1
    fi

    # Edit our file
    nvim "$notes_dir/$edit_file"

    # Delete empty notes files again
    find "$notes_dir" -type f -not -path '*/.git/*' -empty -print -delete

    # Commit anything new
    git -C "$notes_dir" add -A
    if git -C "$notes_dir" diff --cached --quiet; then
      echo "No changes made; nothing to commit."
      exit 0
    fi
    git -C "$notes_dir" commit -m "$commit_msg"

  '';
in {
  environment.systemPackages = [notes];
}
