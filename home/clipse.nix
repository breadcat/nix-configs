{ lib, ... }:
{
  services.clipse = {
    enable = true;
  };

#  wayland.windowManager.hyprland.settings = {
#    bind = [
#      "SUPER, V, exec, alacritty --class clipse -e 'clipse'"
#    ];
#
#    windowrule = [
#      "match:class ^(clipse)$, float 1"
#      "match:class ^(clipse)$, size 622 652"
#    ];
#
#  };

}
