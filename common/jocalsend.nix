{ pkgs, ... }:
{

  # Packages
  environment.systemPackages = with pkgs; [ jocalsend ];

  # Firewall ports
  networking.firewall.allowedTCPPorts = [ 53317 ];
  networking.firewall.allowedUDPPorts = [ 53317 ];

}
