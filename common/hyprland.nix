{ pkgs, username, ... }:

{
  environment.systemPackages = with pkgs; [
    hyprcursor
    hypridle
    hyprland
    seatd
    swayimg
    tofi
    wl-clipboard
  ];
  programs.hyprland.enable = true;
  users.users.${username}.extraGroups = ["seat" "video"];
  services.seatd.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-gtk xdg-desktop-portal-hyprland ];
    config = {
      common.default = "*";
      hyprland = { default = ["hyprland" "gtk"];};
    };
  };

}
