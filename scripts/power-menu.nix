{ pkgs, ... }:

let
  power-menu = pkgs.writeShellScriptBin "power-menu" ''
    choice=$(
    printf '%s\n' \
    'Shut down' \
    'Reboot' \
    'Reboot to EFI' \
    'Exit Hyprland' \
    'Turn off screen' |
    ${pkgs.tofi}/bin/tofi --prompt-text 'Power: '
    )

    case "$choice" in
    'Shut down')
      systemctl poweroff
      ;;

    'Reboot')
      systemctl reboot
      ;;

    'Reboot to EFI')
      systemctl reboot --firmware-setup
      ;;

    'Exit Hyprland')
      hyprctl dispatch 'hl.dsp.exit()'
      ;;

    'Turn off screen')
      hyprctl eval 'hl.config({ misc = { mouse_move_enables_dpms = true, key_press_enables_dpms = true } })'
      sleep 0.5
      hyprctl dispatch 'hl.dsp.dpms({ action = "disable" })'
      ;;
    esac

  '';
in
  {
    environment.systemPackages = [ power-menu ];
  }
