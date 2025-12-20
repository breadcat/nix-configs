# Server

{ config, pkgs, lib, fullname, username, domain, email, sshkey, sshport, timezone, postcode, address, htpasswd, vpnusername, vpnpassword, todosecret, privatekey, matrixuser, matrixserver, ... }:

let machine = "artemis"; in {

  imports = [
    (import ../common/variables.nix { inherit machine fullname username domain email sshkey sshport timezone postcode address htpasswd vpnusername vpnpassword todosecret privatekey matrixuser matrixserver; })
    (import ../common/home-manager.nix  { inherit machine fullname username domain email sshkey sshport timezone postcode address htpasswd vpnusername vpnpassword todosecret privatekey matrixuser matrixserver; })
    ../common/dhcp.nix
    ../common/docker.nix
    ../common/flakes.nix
    ../common/garbage.nix
    ../common/locale.nix
    ../common/mount-drives.nix
    ../common/packages.nix
    ../common/ssh.nix
    ../common/syncthing.nix
    ../common/user.nix
    ../common/vnstat.nix
    ../scripts/blog-duolingo.nix
    ../scripts/blog-status.nix
    ../scripts/magnets.nix
    ../scripts/restic.nix
    ../scripts/stagit-generate.nix
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
      home.stateVersion = "25.05";
  };

  # Hardware and system
  boot = {
    initrd = {
      availableKernelModules = [ "xhci_pci" "virtio_pci" "virtio_scsi" "usbhid" ];
      kernelModules = [ ];
    };
    kernelModules = [ ];
    extraModulePackages = [ ];
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };
  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";

  # Cron jobs
  services.cron = {
    enable = true;
    systemCronJobs = [
      "*/10 * * * * ${username} blog-status"
      "*/10 * * * * ${username} magnets"
      "*/10 * * * * ${username} stagit-generate"
      "55 23 * * SUN  ${username} blog-duolingo"
      "0 */12 * * * ${username} backup-cloud"
    ];
  };

  system.stateVersion = "25.05"; # Did you read the comment?

}