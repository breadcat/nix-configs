# Laptop
{
  config,
  pkgs,
  machine,
  username,
  fullname,
  domain,
  email,
  sshkey,
  sshport,
  ...
}: let
  media-sort = import ../common/media-sort.nix {inherit pkgs;};
  # home-manager = builtins.fetchTarball https://github.com/nix-community/home-manager/archive/release-25.05.tar.gz;
  home-manager = builtins.fetchTarball https://github.com/nix-community/home-manager/archive/master.tar.gz;
in {
  # Core OS imports
  imports = [
    ./${machine}-hardware.nix # Include the results of the hardware scan.
    (import "${home-manager}/nixos") # Home-Manager
    ../common/audio.nix
    ../common/flakes.nix
    ../common/fonts.nix
    ../common/garbage.nix
    ../common/locale.nix
    ../common/nfs.nix
    ../common/packages.nix
    (import ../common/restic.nix {inherit pkgs username;})
    (import ../common/ssh.nix {inherit username sshkey sshport;})
    (import ../common/syncthing.nix {inherit config pkgs username;})
    (import ../common/user.nix {inherit config pkgs username fullname;})
    (import ../common/ydotool.nix {inherit pkgs username;})
    ../scripts/ctimerename.nix
    ../scripts/duupmove.nix
  ];

  # Home-Manager
  home-manager.backupFileExtension = "hm-bak";
  home-manager.users.${username} = {pkgs, ...}: {
    imports = [
      ../home/fish.nix
      ../home/ghostty.nix
      ../home/cursor.nix
      ../home/firefox.nix
      ../home/fish.nix
      ../home/htop.nix
      # ../home/iamb.nix
      ../home/hyprland.nix
      ../home/lf.nix
      ../home/mpv.nix
      ../home/neovim.nix
      ../home/tofi.nix
      (import ../home/git.nix {inherit fullname email;})
      (import ../home/rbw.nix {inherit pkgs domain email;})
      (import ../home/ssh.nix {inherit domain username sshport;})
      (import ../home/newsboat.nix {inherit pkgs domain username;})
    ];
    # The state version is required and should stay at the version you
    # originally installed.
    home.stateVersion = "24.11";
  };

  # Hostname
  networking.hostName = "minerva"; # Define your hostname.

  # Packages
  environment.systemPackages = with pkgs; [
    atool
    media-sort
    brightnessctl
    dos2unix
    firefox
    fzf
    gallery-dl
    glib
    hyprcursor
    hypridle
    hyprland
    imagemagick
    jre8
    lf
    mpv
    newsboat
    pinentry-tty
    posy-cursors
    rbw
    seatd
    swayimg
    tofi
    unzip
    wl-clipboard
    yt-dlp
  ];

  programs.hyprland.enable = true;
  users.users.${username}.extraGroups = ["seat" "video"];
  services.seatd.enable = true;

  system.stateVersion = "24.11"; # Did you read the comment?
}
