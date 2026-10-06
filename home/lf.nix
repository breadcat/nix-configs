{ pkgs, ... }:

{
  programs.lf = {
    enable = true;
    settings = {
      # icons = true;
      ignorecase = true;
      preview = true;
      ratios = "1:2:3";
    };
    keybindings = {
      "." = "set hidden!";
      "<delete>" = "delete";
      "<enter>" = "shell";
      "d" = "delete";
      "i" = "$swayimg -r *";
      "gv" = "cd ~/vault";
    };
    extraConfig = ''
      set previewer ~/.config/lf/previewer
    '';
  };

  home.file.".config/lf/previewer" = {
    executable = true;
    text = ''
    #!/usr/bin/env bash
      set -euo pipefail
      file="$1"
      width="$2"
      height="$3"
      case "$(${pkgs.file}/bin/file -Lb --mime-type -- "$file")" in
      image/*) ${pkgs.chafa}/bin/chafa --format symbols --colors truecolor --size "''${width}x''${height}" --animate off --polite on -- "$file" ;;
      video/*) ${pkgs.ffmpeg}/bin/ffmpeg -hide_banner -loglevel error -i "$file" -vf "thumbnail=100" -frames:v 1 -f image2pipe -c:v mjpeg -q:v 3 pipe:1 | ${pkgs.chafa}/bin/chafa --format symbols --colors truecolor --size "''${width}x''${height}" --polite on --animate off - ;;
      text/*) ${pkgs.bat}/bin/bat --color=always  --style=numbers --pager=never --line-range ":$((height * 2))" -- "$file" ;;
      *) ${pkgs.file}/bin/file -Lb -- "$file" ;;
      esac
    '';
  };

}
