{ lib, machine, ... }:

let
  batteryMachines = [ "minerva" ];
  hasBattery = builtins.elem machine batteryMachines;
  deskModules = [ "media" "cpu" "ram" "storage" "netstat" "volume" "weather" "notifications" "clock" "power" ];
  batModules  = [ "cpu" "ram" "storage" "netstat" "battery" "volume" "weather" "notifications" "clock" "power" ];
in
{
  services.wayle = {
    enable = true;
    # nix-instantiate --eval --expr 'builtins.fromTOML (builtins.readFile ./runtime.toml)' | nixfmt -
    settings = {
      bar = {
        border-color = "bg-hover";
        border-location = "top";
        border-width = 1;
        location = "bottom";
        button-rounding = "none";
        button-variant = "basic";
        layout = [
          {
            left = [ "dashboard" "hyprland-workspaces" "window-title" ];
            center = [ ];
            monitor = "*";
            right = if hasBattery then batModules else deskModules;
            show = true;
          }
        ];
        scale = 0.8;
      };
      modules = {
        cpu = { left-click = "alacritty -e htop"; };
        dashboard = { icon-color = "fg-muted"; };
        hyprland-workspaces = { active-indicator = "underline"; };
        media = { icon-type = "default"; label-max-length= "15"; };
        notifications = { popup-position = "bottom-right"; };
        ram = { left-click = "alacritty -e htop"; };
        weather = { location = "Huddersfield"; };
        window-title = { icon-show = false; };
      };
      styling = {
              palette = {
                bg = "#0d0c0c";
                blue = "#8ba4b0";
                elevated = "#282727";
                fg = "#c5c9c5";
                fg-muted = "#a6a69c";
                green = "#87a987";
                primary = "#8992a7";
                red = "#c4746e";
                surface = "#181616";
                yellow = "#c4b28a";
              };
            };
          };
        };
      }
