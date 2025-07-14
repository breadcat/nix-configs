{ pkgs }:

pkgs.buildGoModule {
  pname = "media-sort";
  version = "2.6.2";

  src = pkgs.fetchFromGitHub {
    owner = "jpillora";
    repo = "media-sort";
    rev = "v2.6.2";
    sha256 = "078bqjlh9n0575apgv4aw6d92bm17riqc5yb64vxg2d9yf9mi4s4";
    # nix-prefetch-url --unpack https://github.com/jpillora/media-sort/archive/refs/tags/v2.6.2.tar.gz
  };

  vendorHash = "sha256-JHnKBr2sxwAXjdrmpkENz4Sm76MmPgNlSVtA8WoXwmA";
  # nix-prefetch-url https://github.com/jpillora/media-sort/archive/refs/tags/v2.6.2.tar.gz | xargs nix hash convert --to sri --hash-algo sha256

  meta = with pkgs.lib; {
    description = "Media sorter – organizes movies and TV into directories";
    homepage = "https://github.com/jpillora/media-sort";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
