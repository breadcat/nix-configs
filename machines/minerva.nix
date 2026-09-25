# Laptop

{ config, pkgs, lib, vars, ... }:

{

  imports = [
    # sort:start
    ../common/audio.nix
    ../common/autologin.nix
    ../common/boot-grub.nix
    ../common/devel.nix
    ../common/flakes.nix
    ../common/fonts.nix
    ../common/garbage.nix
    ../common/home-manager.nix
    ../common/hyprland.nix
    ../common/jocalsend.nix
    ../common/locale.nix
    ../common/mount-drives.nix
    ../common/networking.nix
    ../common/nfs.nix
    ../common/packages.nix
    ../common/speechd.nix
    ../common/ssh.nix
    ../common/syncthing.nix
    ../common/upower.nix
    ../common/user.nix
    ../common/zerotier.nix
    ../scripts/ctimerename.nix
    ../scripts/duupmove.nix
    ../scripts/notes.nix
    ../scripts/restic.nix
    ../scripts/vidyaplace-tears.nix
    ../scripts/vidyaplace.nix
    # sort:end
  ];
  home-manager.users.${vars.user.username} = {pkgs, ...}: { imports = [
        # sort:start
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
        ../home/lf.nix
        ../home/mpv.nix
        ../home/neovim.nix
        ../home/newsboat.nix
        ../home/rbw.nix
        ../home/spotify.nix
        ../home/ssh.nix
        ../home/swayimg.nix
        ../home/tofi.nix
        ../home/wayle.nix
        ../home/yt-dlp.nix
        ../home/zathura.nix
        # sort:end
      ];
      home.stateVersion = "24.11";
    };

  # Hardware and system
  boot.initrd = { availableKernelModules = [ "xhci_pci" "ehci_pci" "ahci" "usb_storage" "sd_mod" "sdhci_pci" ]; };
  boot.kernelModules = [ "kvm-intel" ];
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  # Packages
  environment.systemPackages = with pkgs; [
    brightnessctl
  ];

  system.stateVersion = "24.11"; # Did you read the comment?
}
