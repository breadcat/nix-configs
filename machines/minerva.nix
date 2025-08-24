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
  timezone,
  sshport,
  privatekey,
  ...
}: let
  # home-manager = builtins.fetchTarball https://github.com/nix-community/home-manager/archive/release-25.05.tar.gz;
  home-manager = builtins.fetchTarball https://github.com/nix-community/home-manager/archive/master.tar.gz;
in {
  # Core OS imports
  imports = [
    ./${machine}-hardware.nix # Include the results of the hardware scan.
    (import "${home-manager}/nixos") # Home-Manager
    ../common/audio.nix
    (import ../common/autologin.nix {inherit username;})
    ../common/flakes.nix
    ../common/fonts.nix
    ../common/garbage.nix
    (import ../common/hyprland.nix {inherit pkgs username;})
    (import ../common/locale.nix {inherit timezone;})
    ../common/mount-drives.nix
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
      ../home/cursor.nix
      ../home/firefox.nix
      (import ../home/fish.nix {inherit pkgs domain;})
      ../home/ghostty.nix
      (import ../home/git.nix {inherit fullname email;})
      ../home/htop.nix
      # ../home/iamb.nix
      ../home/hyprland.nix
      ../home/lf.nix
      ../home/mpv.nix
      ../home/neovim.nix
      (import ../home/newsboat.nix {inherit pkgs domain username;})
      (import ../home/rbw.nix {inherit pkgs domain email;})
      (import ../home/ssh.nix {inherit domain username sshport privatekey;})
      ../home/tofi.nix
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
    brightnessctl
    dos2unix
    firefox
    fzf
    gallery-dl
    glib
    imagemagick
    jre8
    lf
    mpv
    newsboat
    pinentry-tty
    posy-cursors
    rbw
    seatd
    shellcheck-minimal
    swayimg
    tofi
    unzip
    wl-clipboard
    yt-dlp
  ];


  system.stateVersion = "24.11"; # Did you read the comment?
}
