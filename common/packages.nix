{ lib, pkgs, ... }: {

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

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "beeper"
    "discord"
    "libretro-genesis-plus-gx"
    "libretro-snes9x"
    "posy-cursors"
    "spotify"
    "steam"
    "steam-unwrapped"
    "unrar"
  ];

}
