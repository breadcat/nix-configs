# HTPC

{ config, pkgs, domain, machine, username, fullname, sshkey, sshport, timezone, privatekey, ... }:

let
  home-manager = builtins.fetchTarball https://github.com/nix-community/home-manager/archive/release-25.05.tar.gz; # stable
  # home-manager = builtins.fetchTarball https://github.com/nix-community/home-manager/archive/master.tar.gz; # unstable
in

{
  # Common OS imports
  imports =
    [
      ./${machine}-hardware.nix # Include the results of the hardware scan.
      (import "${home-manager}/nixos") # Home-Manager
      ../common/audio.nix
      (import ../common/autologin.nix {inherit username;})
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

  # Home-Manager
  home-manager.backupFileExtension = "hm-bak";
  home-manager.users.${username} = { pkgs, ... }: {
    imports = [
      (import ../home/fish.nix {inherit pkgs domain;})
      ../home/ghostty.nix
      ../home/hyprland.nix
      (import ../home/kodi.nix {inherit username;})
      (import ../home/ssh.nix {inherit domain username sshport privatekey;})
    ];

    # The state version is required and should stay at the version you
    # originally installed.
    home.stateVersion = "24.11";
  };

  # Hostname
  networking.hostName = "arcadia"; # Define your hostname.

  # Hardware acceleration
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      libvdpau-va-gl
      vaapiIntel
    ];
  };


  system.stateVersion = "24.11";

}
