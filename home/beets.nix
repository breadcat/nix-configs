{
  programs.beets = {
    enable = true;
    settings = {
      directory = "/tank/media/audio/music";
      library = "/tank/media/audio/music/beets.db";
      threaded = "yes";
      plugins = [ "musicbrainz" "scrub" ];
      ui = {
        color = "yes";
      };
      import = {
        write = true;
        copy = false;
        move = true;
      };
      paths = {
        default = "$albumartist/$year $album/$track $title";
        singleton = "$albumartist/$year $album - $title";
      };
      scrub = {
        auto = true;
      };
    };
  };
}
