# NAS

{ config, pkgs, lib, fullname, username, domain, email, sshkey, sshport, timezone, postcode, address, htpasswd, vpnusername, vpnpassword, todosecret, privatekey, matrixuser, matrixserver, ... }:

let machine = "ilias"; in {

  imports = [
    (import ../common/variables.nix { inherit machine fullname username domain email sshkey sshport timezone postcode address htpasswd vpnusername vpnpassword todosecret privatekey matrixuser matrixserver; })
    (import ../common/home-manager.nix  { inherit machine fullname username domain email sshkey sshport timezone postcode address htpasswd vpnusername vpnpassword todosecret privatekey matrixuser matrixserver; })
    ../common/devel.nix
    ../common/flakes.nix
    ../common/garbage.nix
    ../common/locale.nix
    ../common/mount-drives.nix
    ../common/networking.nix
    ../common/nfs-server.nix
    ../common/packages.nix
    ../common/ssh.nix
    ../common/ssh-tunnel.nix
    ../common/syncthing.nix
    ../common/user.nix
    ../common/zram.nix
    ../scripts/audiobook-cleaner.nix
    ../scripts/backup-local.nix
    ../scripts/blog-music.nix
    ../scripts/blog-sort-archives.nix
    ../scripts/blog-sort-languages.nix
    ../scripts/blog-sort-quotes.nix
    ../scripts/blog-weight.nix
    ../scripts/ctimerename.nix
    ../scripts/duupmove.nix
    ../scripts/overtid.nix
    ../scripts/payslips.nix
    ../scripts/phone-dump.nix
    ../scripts/restic.nix
    ../scripts/seedy.nix
    ../scripts/startpage-sort.nix
    ../scripts/tank-log.nix
    ../scripts/tank-sort.nix
    ../scripts/watchedlist.nix
    ../scripts/xdb.nix
    ../scripts/youtube-id-rss.nix
  ];
  home-manager.users.${username} = {pkgs, ...}: { imports = [
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
  boot = {
    initrd = { availableKernelModules = [ "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" "sr_mod" ]; };
    kernelModules = [ "kvm-intel" ];
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
        "0 */4 * * *  ${username} . /etc/profile; tank-sort"
        "5 */4 * * *  ${username} . /etc/profile; tank-log"
        "0 */12 * * * ${username} backup-cloud"
      ];
    };
  };

  # Packages
  environment.systemPackages = with pkgs; [
    czkawka # duplicate file finder
    jdupes # duplicate file finder
    mmv # mass renamer
    nixfmt-rfc-style
    ocrmypdf
    optipng
    pciutils
    powertop
    python3
    qpdf
    sqlite
  ];

  system.stateVersion = "24.11";
}
