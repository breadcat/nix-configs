{ lib, ... }:
{
  wayland.windowManager.hyprland.settings.input = lib.mkMerge [
    {
      numlock_by_default = true;
    }
  ];
}
