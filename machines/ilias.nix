# NAS

{ config, pkgs, lib, machine, username, email, fullname, domain, sshkey, sshport, timezone, privatekey, ... }:

let
  home-manager = builtins.fetchTarball https://github.com/nix-community/home-manager/archive/release-25.05.tar.gz;
in

{

  networking.hostName = "ilias";

  imports = [
    (import "${home-manager}/nixos")
    ../common/dhcp.nix
    ../common/flakes.nix
    ../common/garbage.nix
    (import ../common/locale.nix {inherit pkgs timezone;})
    ../common/mount-drives.nix
    ../common/nfs-server.nix
    ../common/packages.nix
    (import ../scripts/restic.nix {inherit pkgs;})
    (import ../common/ssh-tunnel.nix {inherit config pkgs username domain sshport privatekey;})
    (import ../common/ssh.nix {inherit username sshkey sshport;})
    (import ../common/syncthing.nix {inherit config pkgs username;})
    (import ../scripts/tank-log.nix {inherit pkgs username;})
    (import ../scripts/tank-sort.nix {inherit pkgs username;})
    (import ../common/user.nix {inherit config pkgs username fullname;})
    (import ../scripts/audiobook-cleaner.nix {inherit pkgs domain;})
    ../scripts/backup-local.nix
    (import ../scripts/blog-music.nix {inherit pkgs domain;})
    (import ../scripts/blog-sort-archives.nix {inherit pkgs domain;})
    (import ../scripts/blog-sort-languages.nix {inherit pkgs domain;})
    (import ../scripts/blog-sort-quotes.nix {inherit pkgs domain;})
    (import ../scripts/blog-weight.nix {inherit pkgs domain;})
    ../scripts/ctimerename.nix
    ../scripts/duupmove.nix
    (import ../scripts/overtid.nix {inherit pkgs;})
    ../scripts/payslips.nix
    ../scripts/phone-dump.nix
    ../scripts/seedy.nix
    ../scripts/startpage-sort.nix
    ../scripts/watchedlist.nix
    ../scripts/youtube-id-rss.nix
  ];
  home-manager = {
    backupFileExtension = "hm-bak";
    users.${username} = {pkgs, ...}: {
      imports = [
        (import ../home/fish.nix {inherit pkgs domain;})
        (import ../home/git.nix {inherit fullname email;})
        ../home/htop.nix
        ../home/neovim.nix
        (import ../home/rbw.nix {inherit pkgs domain email;})
        (import ../home/rclone.nix {inherit domain username sshport privatekey;})
        (import ../home/ssh.nix {inherit domain username sshport privatekey;})
      ];
      home.stateVersion = "24.11";
    };
  };

  # Hardware and system
  boot = {
    initrd = {
      availableKernelModules = [ "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" "sr_mod" ];
      kernelModules = [ ];
    };
    kernelModules = [ "kvm-intel" ];
    extraModulePackages = [ ];
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  swapDevices = [
    { device = "/dev/disk/by-uuid/3397e636-91db-44ae-9572-923e4b3acbbe"; }
  ];

  # Cron jobs
  services = {
    cron = {
      enable = true;
      systemCronJobs = [
        "0 */4 * * *	${username}	tank-sort"
        "5 */4 * * *	${username}	tank-log"
        "0 */12 * * *	${username}	backup-cloud"
      ];
    };
  };

  # Packages
  environment.systemPackages = with pkgs; [
    czkawka
    atool
    dos2unix
    fzf
    gallery-dl
    imagemagick
    jdupes
    mmv
    lf
    mnamer
    mp3val
    nixfmt-rfc-style
    ocrmypdf
    optipng
    opustags
    pciutils
    powertop
    python3
    qpdf
    rbw
    shellcheck-minimal
    shfmt
    sqlite
    unrar
    yt-dlp
  ];

  system.stateVersion = "24.11";
}
