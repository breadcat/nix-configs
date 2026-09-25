# WSL work computer

{ config, lib, pkgs, vars, ... }:

{
  imports = [
    <nixos-wsl/modules> # include NixOS-WSL modules
    # sort:start
    ../common/home-manager.nix
    ../common/locale.nix
    ../common/networking.nix
    ../common/packages.nix
    ../common/syncthing.nix
    ../common/user.nix
    ../common/wsl.nix
    ../scripts/notes.nix
    ../scripts/pbx.nix
    # sort:end
  ];
  home-manager.users.${vars.user.username} = {pkgs, ...}: { imports = [
        # sort:start
        ../home/fish.nix
        ../home/git.nix
        ../home/neovim.nix
        ../home/rbw.nix
        ../home/ssh.nix
        # sort:end
      ];
      home.stateVersion = "26.05";
    };

    environment.systemPackages = with pkgs; [
    # sort:start
    ffmpeg
    gping
    miller
    nmap
    # sort:end
  ];

  system.stateVersion = "26.05"; # Did you read the comment?
}
