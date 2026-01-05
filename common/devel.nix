{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # ide
    geany
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
}
