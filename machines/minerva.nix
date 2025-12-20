# Laptop

{ config, pkgs, lib, fullname, username, domain, email, sshkey, sshport, timezone, postcode, address, htpasswd, vpnusername, vpnpassword, todosecret, privatekey, matrixuser, matrixserver, ... }:

let machine = "minerva"; in {

  imports = [
    (import ../common/variables.nix { inherit machine fullname username domain email sshkey sshport timezone postcode address htpasswd vpnusername vpnpassword todosecret privatekey matrixuser matrixserver; })
    (import ../common/home-manager.nix  { inherit machine fullname username domain email sshkey sshport timezone postcode address htpasswd vpnusername vpnpassword todosecret privatekey matrixuser matrixserver; })
    ../common/audio.nix
    ../common/autologin.nix
    ../common/devel.nix
    ../common/flakes.nix
    ../common/fonts.nix
    ../common/garbage.nix
    ../common/hyprland.nix
    ../common/locale.nix
    ../common/mount-drives.nix
    ../common/networking.nix
    ../common/nfs.nix
    ../common/nur.nix
    ../common/packages.nix
    ../common/packages-unfree.nix
    ../common/ssh.nix
    ../common/syncthing.nix
    ../common/user.nix
    ../common/ydotool.nix
    ../scripts/ctimerename.nix
    ../scripts/duupmove.nix
    ../scripts/restic.nix
    ../scripts/vidyascape.nix
    ../scripts/xdb.nix
  ];
  home-manager.users.${username} = {pkgs, ...}: { imports = [
        ../home/alacritty.nix
        ../home/clipse.nix
        ../home/cursor.nix
        ../home/espanso.nix
        ../home/firefox.nix
        ../home/fish.nix
        ../home/git.nix
        ../home/htop.nix
        ../home/hypridle.nix
        ../home/hyprland.nix
        ../home/iamb.nix
        ../home/lf.nix
        ../home/mpv.nix
        ../home/neovim.nix
        ../home/newsboat.nix
        ../home/rbw.nix
        ../home/ssh.nix
        ../home/tofi.nix
        ../home/yt-dlp.nix
      ];
      home.stateVersion = "24.11";
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

  # Packages
  environment.systemPackages = with pkgs; [
    brightnessctl
  ];

  system.stateVersion = "24.11"; # Did you read the comment?
}
