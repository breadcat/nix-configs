# Laptop

{ config, pkgs, lib, machine, username, fullname, domain, email, sshkey, timezone, sshport, privatekey, ... }:

let
  home-manager = builtins.fetchTarball https://github.com/nix-community/home-manager/archive/master.tar.gz;
in {
  imports = [
    (import "${home-manager}/nixos")
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
    (import ../common/ssh.nix {inherit username sshkey sshport;})
    (import ../common/syncthing.nix {inherit config pkgs username;})
    (import ../common/user.nix {inherit config pkgs username fullname;})
    (import ../common/ydotool.nix {inherit pkgs username;})
    ../scripts/ctimerename.nix
    ../scripts/duupmove.nix
    (import ../scripts/restic.nix {inherit pkgs;})
  ];
  home-manager = {
    backupFileExtension = "hm-bak";
    users.${username} = {pkgs, ...}: {
      imports = [
        ../home/cursor.nix
        ../home/firefox.nix
        (import ../home/fish.nix {inherit pkgs domain;})
        ../home/ghostty.nix
        (import ../home/git.nix {inherit fullname email;})
        ../home/htop.nix
        ../home/hyprland.nix
        ../home/iamb.nix
        ../home/lf.nix
        ../home/mpv.nix
        ../home/neovim.nix
        (import ../home/newsboat.nix {inherit pkgs domain username;})
        (import ../home/rbw.nix {inherit pkgs domain email;})
        (import ../home/ssh.nix {inherit domain username sshport privatekey;})
        ../home/tofi.nix
      ];
      home.stateVersion = "24.11";
    };
  };

  # Hardware and system
  boot = {
    initrd = {
      availableKernelModules = [ "xhci_pci" "ehci_pci" "ahci" "usb_storage" "sd_mod" "sdhci_pci" ];
      kernelModules = [ ];
    };
    kernelModules = [ "kvm-intel" ];
    extraModulePackages = [ ];
    loader.grub = {
      enable = true;
      device = "/dev/sda";
      useOSProber = true;
    };
  };
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  # Networking
  networking = {
    hostName = "minerva";
    networkmanager.enable = true;
    useDHCP = lib.mkDefault true;
  };

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
