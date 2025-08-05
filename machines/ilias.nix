# NAS
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
  ...
}: let
  media-sort = import ../common/media-sort.nix {inherit pkgs;};
  # home-manager = builtins.fetchTarball https://github.com/nix-community/home-manager/archive/release-25.05.tar.gz; # Stable
  home-manager = builtins.fetchTarball https://github.com/nix-community/home-manager/archive/master.tar.gz; # Unstable
in {
  # Core OS imports
  imports = [
    ./${machine}-hardware.nix # Include the results of the hardware scan.
    (import "${home-manager}/nixos") # Home-Manager
    ../common/flakes.nix
    ../common/garbage.nix
    (import ../common/locale.nix {inherit pkgs timezone;})
    (import ../common/magnets.nix {inherit pkgs username;})
    ../common/packages.nix
    (import ../common/restic.nix {inherit pkgs username;})
    (import ../common/ssh-tunnel.nix {inherit config pkgs username domain sshport;})
    (import ../common/ssh.nix {inherit username sshkey sshport;})
    (import ../common/syncthing.nix {inherit config pkgs username;})
    (import ../common/tank-log.nix {inherit pkgs username;})
    (import ../common/tank-sort.nix {inherit pkgs username;})
    (import ../common/user.nix {inherit config pkgs username fullname;})
    (import ../scripts/audiobook-cleaner.nix {inherit pkgs domain;})
    ../scripts/backup-local.nix
    (import ../scripts/blog-music.nix {inherit pkgs domain;})
    (import ../scripts/blog-sort-archives.nix {inherit pkgs domain;})
    (import ../scripts/blog-sort-languages.nix {inherit pkgs domain;})
    (import ../scripts/blog-sort-quotes.nix {inherit pkgs domain;})
    (import ../scripts/blog-weight.nix {inherit pkgs domain;})
    ../scripts/ctimerename.nix
    ../scripts/duupmove.nix
    (import ../scripts/overtid.nix {inherit pkgs;})
    ../scripts/payslips.nix
    ../scripts/phone-dump.nix
    ../scripts/seedy.nix
    ../scripts/stagit-generate.nix
    ../scripts/startpage-sort.nix
    ../scripts/watchedlist.nix
    ../scripts/youtube-id-rss.nix
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
    # The state version is required and should stay at the version you
    # originally installed.
    home.stateVersion = "24.11";
  };

  # Hostname
  networking.hostName = "ilias"; # Define your hostname.

  # Second drive and NFS
  fileSystems."/mnt" = {
    device = "/dev/disk/by-uuid/9b205675-7376-45ba-b575-2f36eb50ea99";
    fsType = "ext4";
  };
  services.nfs.server = {
    enable = true;
    exports = ''
      /mnt    192.168.1.0/24(rw)
    '';
  };
  # Firewall and NFS server ports
  networking.firewall.enable = true;
  networking.firewall.allowPing = true;
  networking.firewall.allowedTCPPorts = [111 2049];
  networking.firewall.allowedUDPPorts = [111 2049];

  # Packages
  environment.systemPackages = with pkgs; [
    czkawka
    atool
    dos2unix
    fzf
    gallery-dl
    imagemagick
    jdupes
    media-sort
    mmv
    lf
    mnamer
    mp3val
    ngrok
    nixfmt-rfc-style
    ocrmypdf
    optipng
    opustags
    pciutils
    powertop
    python3
    qpdf
    rbw
    rclone
    shellcheck-minimal
    shfmt
    sqlite
    unrar
    yt-dlp
  ];

  system.stateVersion = "24.11";
}
