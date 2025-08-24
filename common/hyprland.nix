{ username, ... }:

{
  programs.hyprland.enable = true;
  users.users.${username}.extraGroups = ["seat" "video"];
  services.seatd.enable = true;
}
