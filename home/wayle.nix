{ ... }:

{
  services.wayle = {
    enable = true;
    # nix-instantiate --eval --expr 'builtins.fromTOML (builtins.readFile ./runtime.toml)' | nixfmt -
    settings = {
      bar = {
        border-color = "bg-hover";
        border-location = "bottom";
        border-width = 2;
        button-rounding = "none";
        button-variant = "basic";
        layout = [
          {
            center = [ "media" ];
            left = [ "dashboard" "hyprland-workspaces" "window-title" ];
            monitor = "*";
            right = [ "cpu" "ram" "storage" "netstat" "volume" "weather" "notifications" "clock" "power" ];
            show = true;
          }
        ];
        scale = 0.8;
      };
      modules = {
        cpu = { left-click = "alacritty -e htop"; };
        dashboard = { icon-color = "fg-muted"; };
        hyprland-workspaces = { active-indicator = "underline"; };
        media = { icon-type = "application"; };
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
