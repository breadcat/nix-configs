{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    fastfetch
    ffmpeg
    file
    fish
    fzf
    gallery-dl
    git
    htop
    imagemagick
    jdupes
    lf
    neovim
    rclone
    rsync
    syncthing
    tmux
    unzip
  ];
}
