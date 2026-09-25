{ pkgs, vars, ... }:

{
  environment.systemPackages = with pkgs; [
    # sort:start
    hyprcursor
    hypridle
    hyprland
    seatd
    wl-clipboard
    xdg-utils
    # sort:end
  ];
  programs.hyprland.enable = true;
  users.users.${vars.user.username}.extraGroups = ["seat" "video"];
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
