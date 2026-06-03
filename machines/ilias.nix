# NAS

{ config, pkgs, lib, vars, ... }:

let machine = "ilias"; in {

  imports = [
    ../common/boot-systemd.nix
    ../common/devel.nix
    ../common/flakes.nix
    ../common/garbage.nix
    ../common/home-manager.nix
    ../common/locale.nix
    ../common/mount-drives.nix
    ../common/networking.nix
    ../common/packages.nix
    ../common/roles/bruschetta.nix
    ../common/roles/caddy-${machine}.nix
    ../common/roles/gnocchi.nix
    ../common/roles/nfs-server.nix
    ../common/roles/stromboli.nix
    ../common/roles/tagliatelle.nix
    ../common/ssh.nix
    ../common/ssh-tunnel.nix
    ../common/syncthing.nix
    ../common/user.nix
    ../common/zerotier.nix
    ../scripts/audiobook-cleaner.nix
    ../scripts/backup-local.nix
    ../scripts/blog-music.nix
    ../scripts/blog-sort-archives.nix
    ../scripts/blog-sort-languages.nix
    ../scripts/blog-sort-quotes.nix
    ../scripts/blog-weight.nix
    ../scripts/ctimerename.nix
    ../scripts/duupmove.nix
    ../scripts/duplicate-filenames.nix
    ../scripts/overtid.nix
    ../scripts/payslips.nix
    ../scripts/phone-dump.nix
    ../scripts/restic.nix
    ../scripts/seedy.nix
    ../scripts/startpage-sort.nix
    ../scripts/tank-log.nix
    ../scripts/tank-sort.nix
    ../scripts/taudiobooker.nix
    ../scripts/watchedlist.nix
    ../scripts/youtube-id-rss.nix
  ];
  home-manager.users.${vars.user.username} = {pkgs, ...}: { imports = [
        ../home/fish.nix
        ../home/git.nix
        ../home/htop.nix
        ../home/neovim.nix
        ../home/rbw.nix
        ../home/rclone.nix
        ../home/ssh.nix
        ../home/yt-dlp.nix
      ];
      home.stateVersion = "24.11";
  };

  # Hardware and system
  boot.initrd = { availableKernelModules = [ "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" "sr_mod" ]; };
  boot.kernelModules = [ "kvm-intel" ];
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  swapDevices = [
    { device = "/dev/disk/by-uuid/3397e636-91db-44ae-9572-923e4b3acbbe"; }
  ];

  # Packages
  environment.systemPackages = with pkgs; [
    czkawka # duplicate file finder
    jdupes # duplicate file finder
    mmv # mass renamer
    optipng
    pciutils
    powertop
    python3
    qpdf
    sqlite
  ];

  system.stateVersion = "24.11";
}
