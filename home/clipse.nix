{ lib, ... }:
{
  services.clipse = {
    enable = true;
  };

  wayland.windowManager.hyprland.settings = {
    bind = [
      "SUPER, V, exec, alacritty --class clipse -e 'clipse'"
    ];

    windowrulev2 = [
      "float,class:(clipse)"
      "size 622 652,class:(clipse)"
    ];
  };

}
