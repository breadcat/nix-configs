{ pkgs, ... }: {
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    fastfetch
    ffmpeg
    file
    fish
    fzf
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
