# HTPC

{ config, pkgs, lib, domain, machine, username, fullname, sshkey, sshport, timezone, privatekey, ... }:

let
  home-manager = builtins.fetchTarball https://github.com/nix-community/home-manager/archive/release-25.05.tar.gz;
in

{

  networking.hostName = "arcadia";

  imports =
    [
      (import "${home-manager}/nixos") # Home-Manager
      ../common/audio.nix
      (import ../common/autologin.nix {inherit username;})
      ../common/dhcp.nix
      ../common/flakes.nix
      ../common/garbage.nix
      (import ../common/hyprland.nix {inherit pkgs username;})
      (import ../common/kodi.nix {inherit pkgs username;})
      (import ../common/locale.nix {inherit config pkgs timezone;})
      ../common/mount-drives.nix
      ../common/nfs.nix
      ../common/packages.nix
      (import ../common/ssh.nix {inherit username sshkey sshport privatekey;})
      (import ../common/syncthing.nix {inherit config pkgs username;})
      (import ../common/user.nix {inherit config pkgs username fullname;})
      ../scripts/htpc-launcher.nix
    ];
  home-manager = {
    backupFileExtension = "hm-bak";
    users.${username} = { pkgs, ... }: {
    imports = [
      (import ../home/fish.nix {inherit pkgs domain;})
      ../home/ghostty.nix
      ../home/hyprland.nix
      (import ../home/kodi.nix {inherit username;})
      (import ../home/ssh.nix {inherit domain username sshport privatekey;})
    ];
    home.stateVersion = "24.11";
    };
  };

  # Hardware and system
  boot = {
    initrd = {
      availableKernelModules = [ "xhci_pci" "ehci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
      kernelModules = [ ];
    };
    kernelModules = [ "kvm-intel" ];
    extraModulePackages = [ ];
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware = {
    cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    graphics = {
      enable = true;
      extraPackages = with pkgs; [ intel-media-driver libvdpau-va-gl vaapiIntel ];
    };
  };

  system.stateVersion = "24.11";

}
