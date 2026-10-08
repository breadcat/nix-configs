{ pkgs, vars, ... }:

{
  # Kodi package is installed via home-manager in home/kodi.nix

  # Firewall rules
  networking.firewall = {
      allowedTCPPorts = [ 8080 ];
      allowedUDPPorts = [ 8080 ];
    };

  # Extra groups for Kodi CEC input
  users.users.${vars.user.username}.extraGroups = [ "networkmanager" "wheel" "input" "dialout" "video" ];

  # Fix timezone zoneinfo
  systemd.tmpfiles.rules = [ "L+ /usr/share/zoneinfo - - - - ${pkgs.tzdata}/share/zoneinfo" ];
}
