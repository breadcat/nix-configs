{ pkgs, ... }:

{
  programs.mpv = {
    enable = true;
    config = {
      volume = 50; # initial volume
      audio-display = "no";
      sub-auto = "fuzzy";
      ytdl-raw-options = "sub-format=en,write-srt=";
      ytdl-format = "bestvideo[height<=?480][fps<=?30]+bestaudio/best";
    };
    scripts = with pkgs.mpvScripts; [ sponsorblock-minimal ];

    profiles = builtins.listToAttrs (
      map (ext: { name = "extension.${ext}"; value = { loop-file = "inf"; }; })
      [ "gif" "webm" ]
      ++
      map (ext: { name = "extension.${ext}"; value = { pause = "yes"; }; })
      [ "jpg" "jpeg" "webp" "png" "avif" ]
    );

    bindings = {
      "-" = "add volume -5";
      "=" = "add volume 5";
      PGDWN = "playlist-prev";
      PGUP = "playlist-next";
      x = "cycle sub";
      X = "cycle sub-visibility";
      "Ctrl+n" = "af toggle acompressor";
      "Alt+-" = "add video-zoom -0.02";
      "Alt+=" = "add video-zoom 0.02";
      RIGHT = "osd-msg-bar seek +5 exact";
      LEFT = "osd-msg-bar seek -5 exact";
      "ctrl+del" = "run rm '$\{path\}'";
    };
  };
}
