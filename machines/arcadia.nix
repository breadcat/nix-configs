# HTPC

{ config, pkgs, lib, vars, ... }:

{

  imports = [
    # sort:start
    # ../common/cec-mini-kb.nix
    ../common/audio.nix
    ../common/autologin.nix
    ../common/boot-systemd.nix
    ../common/flakes.nix
    ../common/fonts.nix
    ../common/garbage.nix
    ../common/home-manager.nix
    ../common/hyprland.nix
    ../common/kodi.nix
    ../common/locale.nix
    ../common/mount-drives.nix
    ../common/networking.nix
    ../common/nfs.nix
    ../common/packages.nix
    ../common/ssh.nix
    ../common/syncthing.nix
    ../common/user.nix
    ../scripts/seedy.nix
    # sort:end
  ];
  home-manager.users.${vars.user.username} = {pkgs, ...}: { imports = [
      # sort:start
      ../home/alacritty.nix
      ../home/firefox.nix
      ../home/fish.nix
      ../home/hyprland.nix
      ../home/kodi.nix
      ../home/rclone.nix
      ../home/retroarch.nix
      ../home/spotify.nix
      ../home/ssh.nix
      ../home/yt-dlp.nix
      # sort:end
    ];
    home.stateVersion = "24.11";
  };

  # Hardware and system
  boot.initrd = { availableKernelModules = [ "xhci_pci" "ehci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ]; };
  boot.kernelModules = [ "kvm-intel" ];
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware = {
    cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    graphics = {
      enable = true;
      extraPackages = with pkgs; [ intel-media-driver libvdpau-va-gl intel-vaapi-driver ];
    };
  };

  system.stateVersion = "24.11";

}
