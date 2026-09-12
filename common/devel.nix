{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # graphical git
    gitg
    # basic notepad
    mousepad
    # bash
    shellcheck-minimal
    shfmt
    # go
    go
    # gcc
    gcc
    # web
    hugo
    # nix
    nixfmt
  ];
}
