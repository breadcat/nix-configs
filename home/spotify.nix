{ config, pkgs, ... }:

{
  programs.spotify-player = {
    enable = true;
  };

  home.packages = with pkgs; [ playerctl ];
}
