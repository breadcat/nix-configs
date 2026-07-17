# WSL work computer

{ config, lib, pkgs, vars, ... }:

{
  imports = [
    <nixos-wsl/modules> # include NixOS-WSL modules
    ../common/home-manager.nix
    ../common/networking.nix
    ../common/packages.nix
    ../common/syncthing.nix
    ../common/user.nix
    ../common/wsl.nix
    ../scripts/pbx.nix
  ];
  home-manager.users.${vars.user.username} = {pkgs, ...}: { imports = [
        ../home/fish.nix
        ../home/neovim.nix
        ../home/rbw.nix
        ../home/ssh.nix
      ];
      home.stateVersion = "26.05";
  };

  environment.systemPackages = with pkgs; [
    ffmpeg
    gping
    nmap
  ];

  system.stateVersion = "26.05"; # Did you read the comment?
}
