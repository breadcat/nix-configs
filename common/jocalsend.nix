{ lib, pkgs, ... }:
{

  # Packages
  environment.systemPackages = with pkgs; [ jocalsend ];
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [ "jocalsend" ];

  # Firewall ports
  networking.firewall.allowedTCPPorts = [ 53317 ];
  networking.firewall.allowedUDPPorts = [ 53317 ];

}
