{
  programs.yt-dlp = {
    enable = true;
    extraConfig = ''
      --no-playlist"
    '';
  };
}
