{ pkgs, vars, ... }:

{
  # Package and Addons
  environment.systemPackages = with pkgs; [ kodi-wayland ];

  # Firewall rules
  networking.firewall = {
      allowedTCPPorts = [ 8080 ];
      allowedUDPPorts = [ 8080 ];
    };

  # Extra groups for Kodi CEC input
  users.users.${vars.user.username}.extraGroups = [ "networkmanager" "wheel" "input" "dialout" "video" ];
}
