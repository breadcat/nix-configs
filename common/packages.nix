{ pkgs, ... }: {
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    fastfetch
    ffmpeg
    file
    fish
    git
    htop
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
