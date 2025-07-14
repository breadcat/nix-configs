# HTPC

{ config, pkgs, domain, machine, username, fullname, sshkey, ... }:

let
  home-manager = builtins.fetchTarball https://github.com/nix-community/home-manager/archive/release-25.05.tar.gz; # stable
  # home-manager = builtins.fetchTarball https://github.com/nix-community/home-manager/archive/master.tar.gz; # unstable
in

{
  # Common OS imports
  imports =
    [ # Include the results of the hardware scan.
      ./${machine}-hardware.nix
      ../common/audio.nix
      ../common/flakes.nix
      ../common/garbage.nix
      ../common/locale.nix
      ../common/nfs.nix
      # ../common/kodi-module.nix
      ../common/packages.nix
      (import ../common/syncthing.nix {inherit config pkgs username;})
      (import ../common/user.nix {inherit config pkgs username fullname;})
      (import ../common/ssh.nix {inherit username sshkey;})
      ../scripts/htpc-launcher.nix
      (import "${home-manager}/nixos")
    ];

  # Home-Manager
  home-manager.backupFileExtension = "hm-bak";
  home-manager.users.${username} = { pkgs, ... }: {
    imports = [
      ../home/fish.nix
      ../home/hyprland.nix
      (import ../home/kodi.nix {inherit username;})
      (import ../home/ssh.nix {inherit domain username;})
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

  # Enable programs
  programs.hyprland.enable = true;

  # Packages
  environment.systemPackages = with pkgs; [
    alacritty
    # duckstation
    hyprland
    kodiPackages.inputstream-adaptive
    kodi-wayland
    moonlight-qt
    mpv
    # spotify
    yt-dlp
  ];

  # Kodi settings
  # HDMI CEC input groups
  users.users.${username}.extraGroups = [ "networkmanager" "wheel" "input" "dialout" "video" ]; # Extra groups for Kodi CEC input

  # Web UI firewall rules
  networking.firewall.allowedTCPPorts = [ 8080 ];
  networking.firewall.allowedUDPPorts = [ 8080 ];

  system.stateVersion = "24.11";

}
