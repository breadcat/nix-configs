{ lib, ... }:
{
  services.clipse.enable = true;

  wayland.windowManager.hyprland.extraConfig = ''
    hl.bind("SUPER + V", hl.dsp.exec_cmd("alacritty --class clipse -e 'clipse'"))
    hl.window_rule({name="clipse-float",match={class="^(clipse)$"},float=true,size={622,652}})
  '';

}
