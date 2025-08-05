# Server
{
  config,
  pkgs,
  machine,
  username,
  email,
  fullname,
  domain,
  sshkey,
  sshport,
  timezone,
  todosecret,
  vpnusername,
  vpnpassword,
  ...
}: let
  home-manager = builtins.fetchTarball https://github.com/nix-community/home-manager/archive/release-25.05.tar.gz; # Stable
  # home-manager = builtins.fetchTarball https://github.com/nix-community/home-manager/archive/master.tar.gz; # Unstable
in {
  # Core OS imports
  imports =
    [
    ./${machine}-hardware.nix # Include the results of the hardware scan.
    (import "${home-manager}/nixos") # Home-Manager
    (import ../common/docker.nix {inherit config pkgs username domain timezone todosecret vpnusername vpnpassword;})
    ../common/flakes.nix
    ../common/garbage.nix
    (import ../common/locale.nix {inherit pkgs timezone;})
    ../common/packages.nix
    (import ../common/restic.nix {inherit pkgs username;})
    (import ../common/ssh.nix {inherit username sshkey sshport;})
    (import ../common/syncthing.nix {inherit config pkgs username;})
    (import ../common/user.nix {inherit config pkgs username fullname;})
    ../scripts/stagit-generate.nix
    ];

  # Home-Manager
  home-manager.backupFileExtension = "hm-bak";
  home-manager.users.${username} = {pkgs, ...}: {
    imports = [
      ../home/fish.nix
      (import ../home/git.nix {inherit fullname email;})
      ../home/htop.nix
      ../home/neovim.nix
      (import ../home/rbw.nix {inherit pkgs domain email;})
      (import ../home/ssh.nix {inherit domain username sshport;})
    ];
    home.stateVersion = "25.05";
  };

  networking.hostName = "artemis"; # Define your hostname.

  system.stateVersion = "25.05"; # Did you read the comment?

}
