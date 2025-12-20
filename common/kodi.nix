{ pkgs, username, ... }:

{
  # Package and Addons
  environment.systemPackages = with pkgs; [
    (kodi-wayland.withPackages (kodiPkgs: with kodiPkgs; [
      a4ksubtitles
      inputstream-adaptive
      somafm
      upnext
      youtube
    ]))
  ];

  # Firewall rules
  networking.firewall = {
      allowedTCPPorts = [ 8080 ];
      allowedUDPPorts = [ 8080 ];
    };

  # Extra groups for Kodi CEC input
  users.users.${username}.extraGroups = [ "networkmanager" "wheel" "input" "dialout" "video" ];
}
