# HTPC

{ config, pkgs, lib, fullname, username, domain, email, sshkey, sshport, timezone, postcode, address, htpasswd, vpnusername, vpnpassword, todosecret, privatekey, matrixuser, matrixserver, ... }:

let machine = "arcadia"; in {

  imports = [
    (import ../common/variables.nix { inherit machine fullname username domain email sshkey sshport timezone postcode address htpasswd vpnusername vpnpassword todosecret privatekey matrixuser matrixserver; })
    (import ../common/home-manager.nix  { inherit machine fullname username domain email sshkey sshport timezone postcode address htpasswd vpnusername vpnpassword todosecret privatekey matrixuser matrixserver; })
    ../common/audio.nix
    ../common/autologin.nix
    ../common/boot-systemd.nix
    ../common/emulators.nix
    ../common/flakes.nix
    ../common/fonts.nix
    ../common/garbage.nix
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
    ];
  home-manager.users.${username} = {pkgs, ...}: { imports = [
      ../home/alacritty.nix
      ../home/fish.nix
      ../home/hyprland.nix
      ../home/kodi.nix
      ../home/rclone.nix
      ../home/ssh.nix
      ../home/yt-dlp.nix
    ];
    home.stateVersion = "24.11";
  };

  # Hardware and system
  boot.initrd = { availableKernelModules = [ "xhci_pci" "ehci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ]; };
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
