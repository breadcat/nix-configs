# Desktop

{ config, pkgs, lib, machine, username, fullname, domain, email, sshkey, timezone, sshport, privatekey, matrixuser, matrixserver, ... }:

let
   home-manager = builtins.fetchTarball https://github.com/nix-community/home-manager/archive/master.tar.gz;
in

{

  networking.hostName = "atlas";

  imports = [
    (import "${home-manager}/nixos")
    ../common/audio.nix
    (import ../common/autologin.nix {inherit username;})
    (import ../common/devel.nix {inherit pkgs;})
    ../common/dhcp.nix
    ../common/flakes.nix
    ../common/fonts.nix
    ../common/garbage.nix
    (import ../common/hyprland.nix {inherit pkgs username;})
    (import ../common/locale.nix {inherit timezone;})
    ../common/mount-drives.nix
    ../common/nfs.nix
    ../common/packages.nix
    ../common/steam.nix
    (import ../common/ssh.nix {inherit username sshkey sshport;})
    (import ../common/syncthing.nix {inherit config pkgs username;})
    (import ../common/user.nix {inherit config pkgs username fullname;})
    (import ../common/ydotool.nix {inherit pkgs username;})
    ../scripts/ctimerename.nix
    ../scripts/duupmove.nix
    ../scripts/xdb.nix
    (import ../scripts/vidyascape.nix {inherit pkgs;})
    (import ../scripts/restic.nix {inherit pkgs;})
  ];
  home-manager = {
    backupFileExtension = "hm-bak";
    users.${username} = {pkgs, ...}: {
      imports = [
        ../home/alacritty.nix
        ../home/cursor.nix
        ../home/espanso.nix
        ../home/firefox.nix
        (import ../home/fish.nix {inherit pkgs domain;})
        (import ../home/git.nix {inherit fullname email;})
        ../home/htop.nix
        ../home/hyprland-numlock.nix
        ../home/hyprland.nix
        (import ../home/iamb.nix {inherit matrixuser matrixserver;})
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
      availableKernelModules = [ "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
      kernelModules = [ ];
    };
    kernelModules = [ "kvm-intel" ];
    extraModulePackages = [ ];
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    };
  hardware.firmware = [ pkgs.linux-firmware ];
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  # Packages
  environment.systemPackages = with pkgs; [
    ntfs3g
    glib
  ];

  system.stateVersion = "24.11"; # Did you read the comment?

}
