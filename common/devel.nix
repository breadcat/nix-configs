{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # bash
    shellcheck-minimal
    shfmt
    # go
    go
    # gcc
    gcc
    # web
    hugo
  ];
  # networking.firewall.allowedTCPPorts = [ 8080 ]; # nixos-firewall-tool open tcp 8080
}
