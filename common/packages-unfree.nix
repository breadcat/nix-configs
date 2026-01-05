{ lib, ... }:

{
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "posy-cursors"
    "spotify"
    "steam"
    "steam-unwrapped"
    "unrar"
  ];
}
