{ pkgs, username, ... }:

{
  environment.systemPackages = with pkgs; [
    hyprcursor
    hypridle
    hyprland
    ];
  programs.hyprland.enable = true;
  users.users.${username}.extraGroups = ["seat" "video"];
  services.seatd.enable = true;
}
