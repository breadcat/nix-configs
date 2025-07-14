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
    neovim
    rclone
    rsync
    syncthing
    tmux
    unzip
  ];
}
