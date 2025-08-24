# Server

{ config, pkgs, lib, machine, username, email, fullname, domain, sshkey, sshport, timezone, htpasswd, todosecret, vpnusername, vpnpassword, privatekey, ... }:

let
  home-manager = builtins.fetchTarball https://github.com/nix-community/home-manager/archive/release-25.05.tar.gz;
in

{
  imports = [
    (import "${home-manager}/nixos")
    (import ../scripts/blog-duolingo.nix {inherit pkgs domain username;})
    (import ../scripts/blog-status.nix {inherit pkgs domain;})
    (import ../common/docker.nix {inherit config pkgs username domain timezone htpasswd todosecret vpnusername vpnpassword;})
    ../common/flakes.nix
    ../common/garbage.nix
    (import ../common/locale.nix {inherit pkgs timezone;})
    (import ../scripts/magnets.nix {inherit pkgs;})
    ../common/mount-drives.nix
    ../common/packages.nix
    (import ../scripts/restic.nix {inherit pkgs;})
    (import ../common/ssh.nix {inherit username sshkey sshport;})
    (import ../common/syncthing.nix {inherit config pkgs username;})
    (import ../common/user.nix {inherit config pkgs username fullname;})
    ../common/vnstat.nix
    (import ../scripts/stagit-generate.nix {inherit pkgs;})
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
      home.stateVersion = "25.05";
    };
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
  networking = {
    hostName = "artemis";
    useDHCP = lib.mkDefault true;
  };

  # Cron jobs
  services.cron = {
    enable = true;
    systemCronJobs = [
      "*/10 * * * *	${username}	blog-status"
      "*/10 * * * *	${username}	magnets"
      "*/10 * * * *	${username}	stagit-generate"
      "55 23 * * SUN	${username}	blog-duolingo"
      "0 */12 * * *	${username}	backup-cloud"
    ];
  };

  system.stateVersion = "25.05"; # Did you read the comment?

}