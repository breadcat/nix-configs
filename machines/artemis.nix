# Server

{ config, pkgs, lib, fullname, username, domain, email, sshkey, sshport, timezone, postcode, address, htpasswd, vpnusername, vpnpassword, todosecret, privatekey, matrixuser, matrixserver, ... }:

let machine = "artemis"; in {

  imports = [
    (import ../common/variables.nix { inherit machine fullname username domain email sshkey sshport timezone postcode address htpasswd vpnusername vpnpassword todosecret privatekey matrixuser matrixserver; })
    (import ../common/home-manager.nix  { inherit machine fullname username domain email sshkey sshport timezone postcode address htpasswd vpnusername vpnpassword todosecret privatekey matrixuser matrixserver; })
    ../common/dhcp.nix
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