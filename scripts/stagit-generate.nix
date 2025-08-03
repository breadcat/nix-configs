{pkgs, ...}: let
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
	  mkdir -p "$destination_directory"
	  # stagit loop
	  for repo in $(find "$source_directory" -type d -name '.git' | sed 's|/\.git$||'); do
		output_directory="$destination_directory/$(basename "$repo")"
		mkdir -p "$output_directory"
		cd "$output_directory" || exit
		echo "Generating $(basename "$repo")..."
		${pkgs.stagit}/bin/stagit "$repo"
		cat > "style.css" <<EOF
		${css}
EOF
	  done
	  # index
	  cd "$destination_directory" || exit
	  ${pkgs.stagit}/bin/stagit-index "''${source_directory}/"*/ >index.html
	  cat > "style.css" <<EOF
	  ${css}
EOF
  '';
in {
  environment.systemPackages = [stagit-generate];
}
