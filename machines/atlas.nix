# Desktop

{ config, pkgs, lib, fullname, username, domain, email, sshkey, sshport, timezone, postcode, address, htpasswd, vpnusername, vpnpassword, todosecret, privatekey, matrixuser, matrixserver, ... }:

let machine = "atlas"; in {

  imports = [
    (import ../common/variables.nix { inherit machine fullname username domain email sshkey sshport timezone postcode address htpasswd vpnusername vpnpassword todosecret privatekey matrixuser matrixserver; })
    (import ../common/home-manager.nix  { inherit machine fullname username domain email sshkey sshport timezone postcode address htpasswd vpnusername vpnpassword todosecret privatekey matrixuser matrixserver; })
    ../common/audio.nix
    ../common/autologin.nix
    ../common/boot-systemd.nix
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
    ../common/scanning.nix
    ../common/ssh.nix
    ../common/steam.nix
    ../common/syncthing.nix
    ../common/user.nix
    ../common/ydotool.nix
    ../common/zram.nix
    ../scripts/ctimerename.nix
    ../scripts/duupmove.nix
    ../scripts/restic.nix
    ../scripts/seedy.nix
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
    ../home/github-desktop.nix
    ../home/htop.nix
    ../home/hypridle.nix
    ../home/hyprland-numlock.nix
    ../home/hyprland.nix
    ../home/iamb.nix
    ../home/lf.nix
    ../home/mpv.nix
    ../home/neovim.nix
    ../home/newsboat.nix
    ../home/rbw.nix
    ../home/rclone.nix
    ../home/ssh.nix
    ../home/tofi.nix
    ../home/yt-dlp.nix
  ];
  home.stateVersion = "24.11";
};

  # Hardware and system
  boot.initrd = { availableKernelModules = [ "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ]; };
  boot.kernelModules = [ "kvm-intel" ];
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
  ];

  system.stateVersion = "24.11"; # Did you read the comment?

}
