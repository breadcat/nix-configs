{ pkgs, username, ...}: let
  css = ''
    body,pre{font-family:monospace}
    #blob,article img{max-width:100%}
    html{font-size:12px;height:100%}
    body{margin:5rem auto;color:#aaa;background-color:#272727;width:66rem}
    pre{-moz-tab-size:4;tab-size:4}
    h1,h2,h3,h4,h5,h6{font-size:1em;margin:0}
    h1,h2,img{vertical-align:middle}
    img{border:0}
    a,a.d,a.h,a.i,a.line{color:#3498db;text-decoration:none}
    #blob{display:block;overflow-x:scroll}
    article.markup{font-size:15px;border:2px solid #00000017;border-radius:10px;font-family:sans-serif;padding:2.5em;margin:2em 0}
    article.markup code{font-size:.9em;border:1px solid #dbdbdb;background-color:#f7f7f7;padding:0 .3em;border-radius:.3em}
    article.markup pre code{border:none;background:0 0;padding:0;border-radius:0}
    article.markup pre{background-color:#f7f7f7;padding:1em;border:1px solid #dbdbdb;border-radius:.3em}
    article.markup h1{font-size:2.4em;padding-bottom:6px;border-bottom:5px solid #0000000a}
    article.markup h2{font-size:1.9em;padding-bottom:5px;border-bottom:2px solid #00000014}
    article.markup h3{font-size:1.5em}
    article.markup h4{font-size:1.3em}
    article.markup h5{font-size:1.1em}
    article.markup h6{font-size:1em}
    .linenos{margin-right:0;border-right:1px solid;user-select:none}
    .linenos a{margin-right:.9em;user-select:none;text-decoration:none}
    #blob a,.desc{color:#777}
    table thead td{font-weight:700}
    table td{padding:0 .4em}
    #content table td{vertical-align:top;white-space:nowrap}
    #branches tr:hover td,#files tr:hover td,#index tr:hover td,#log tr:hover td,#tags tr:hover td{background-color:#414141}
    #branches tr td:nth-child(3),#index tr td:nth-child(2),#log tr td:nth-child(2),#tags tr td:nth-child(3){white-space:normal}
    td.num{text-align:right}
    hr{border:0;border-top:1px solid #777;height:1px}
    .A,pre a.i,span.i{color:#29b74e}
    .D,pre a.d,span.d{color:#e42533}
    .url td:nth-child(2){padding-top:.2em;padding-bottom:.9em}
    .url td:nth-child(2) span{padding:1px 5px;background-color:#eee;border:1px solid #ddd;border-radius:5px}
    .url td:nth-child(2) span a{color:#444}
  '';
  stagit-generate = pkgs.writeShellScriptBin "stagit-generate" ''
    # variables
    source_directory="$HOME/vault/src"
    destination_directory="$HOME/docker/stagit"
    state_file="$destination_directory/.stagit-state"

    mkdir -p "$destination_directory"

    # state file
    if [ ! -f "$state_file" ]; then
      echo "# stagit-generate state file" > "$state_file"
      echo "# format: repo_path:last_commit_hash" >> "$state_file"
    fi
    get_latest_commit() {
      local repo_path="$1"
      cd "$repo_path" || return 1
      git rev-parse HEAD 2>/dev/null || echo "no-commits"
    }
    get_stored_commit() {
      local repo_name="$1"
      grep "^$repo_name:" "$state_file" 2>/dev/null | cut -d':' -f2- || echo ""
    }
    update_stored_commit() {
      local repo_name="$1"
      local commit_hash="$2"
      grep -v "^$repo_name:" "$state_file" > "$state_file.tmp" 2>/dev/null || touch "$state_file.tmp"
      echo "$repo_name:$commit_hash" >> "$state_file.tmp"
      mv "$state_file.tmp" "$state_file"
    }

    updated_repos=0
    skipped_repos=0
    index_needs_update=false

    # stagit loop
    for repo in $(find "$source_directory" -type d -name '.git' | sed 's|/\.git$||'); do
      repo_name=$(basename "$repo")
      output_directory="$destination_directory/$repo_name"
      current_commit=$(get_latest_commit "$repo")
      stored_commit=$(get_stored_commit "$repo_name")

      # repo update check
      if [ "$current_commit" != "$stored_commit" ] || [ ! -d "$output_directory" ]; then
        echo "Updating $repo_name... (was: $stored_commit, now: $current_commit)"

        mkdir -p "$output_directory"
        cd "$output_directory" || exit

        ${pkgs.stagit}/bin/stagit "$repo"

        cat > "style.css" <<EOF
        ${css}
EOF

        # update state
        update_stored_commit "$repo_name" "$current_commit"
        updated_repos=$((updated_repos + 1))
        index_needs_update=true
      else
        echo "Skipping $repo_name (no changes since $stored_commit)"
        skipped_repos=$((skipped_repos + 1))
      fi
    done

    # re-generate index repositories were updated
    if [ "$index_needs_update" = true ]; then
      echo "Regenerating index..."
      cd "$destination_directory" || exit
      ${pkgs.stagit}/bin/stagit-index "''${source_directory}/"*/ >index.html
      cat > "style.css" <<EOF
      ${css}
EOF
    else
      echo "Index unchanged, skipping re-generation"
    fi

    echo "Summary: Updated $updated_repos repositories, skipped $skipped_repos repositories"
  '';
in {
  environment.systemPackages = [stagit-generate];

  # Systemd service and timer configuration
  systemd.services.stagit-generate = {
    serviceConfig = {
      Type = "oneshot";
      User = "${username}";
      ExecStart = "${stagit-generate}/bin/stagit-generate";
      StandardOutput = "journal";
      StandardError = "journal";
    };
  };

  systemd.timers.stagit-generate = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "*-*-* 00,04,08,12,16,20:00:00";
      RandomizedDelaySec = "15m";
      Persistent = true;
      AccuracySec = "1m";
    };
  };
}