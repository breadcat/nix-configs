# Server

{ config, pkgs, lib, vars, ... }:

let machine = "artemis"; in {

  imports = [
    (import ../common/variables.nix { inherit machine vars; })
    (import ../common/home-manager.nix  { inherit machine vars; })
    ../common/boot-systemd.nix
    ../common/docker.nix
    ../common/docker-webdev.nix
    ../common/flakes.nix
    ../common/garbage.nix
    ../common/locale.nix
    ../common/mount-drives.nix
    ../common/networking.nix
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
    ../scripts/taudiobooker.nix
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
  boot.initrd = { availableKernelModules = [ "xhci_pci" "virtio_pci" "virtio_scsi" "usbhid" ]; };
  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";

  # Cron jobs
  services.cron = {
    enable = true;
    systemCronJobs = [
      "*/10 * * * * ${vars.user.username} blog-status"
      "*/10 * * * * ${vars.user.username} magnets"
      "*/10 * * * * ${vars.user.username} stagit-generate"
      "55 23 * * SUN  ${vars.user.username} blog-duolingo"
      "0 */12 * * * ${vars.user.username} backup-cloud"
    ];
  };

  system.stateVersion = "25.05"; # Did you read the comment?

}