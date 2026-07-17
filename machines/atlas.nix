# Desktop

{ config, pkgs, lib, vars, ... }:

{

  imports = [
    ../common/audio.nix
    ../common/autologin.nix
    ../common/boot-systemd.nix
    ../common/devel.nix
    ../common/flakes.nix
    ../common/fonts.nix
    ../common/garbage.nix
    ../common/home-manager.nix
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
    ../scripts/ctimerename.nix
    ../scripts/duplicate-filenames.nix
    ../scripts/duupmove.nix
    ../scripts/restic.nix
    ../scripts/scan-to-pdf.nix
    ../scripts/seedy.nix
    ../scripts/taudiobooker.nix
    ../scripts/vidyaplace.nix
  ];
  home-manager.users.${vars.user.username} = {pkgs, ...}: { imports = [
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
    ../home/hyprland.nix
    ../home/lf.nix
    ../home/mpv.nix
    ../home/neovim.nix
    ../home/newsboat.nix
    ../home/rbw.nix
    ../home/rclone.nix
    ../home/spotify.nix
    ../home/ssh.nix
    ../home/tofi.nix
    ../home/wayle.nix
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
    discord
    ntfs3g
  ];

  system.stateVersion = "24.11"; # Did you read the comment?

}
