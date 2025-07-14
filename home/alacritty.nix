{
  programs.alacritty = {
    enable = true;
    settings = {
      font = {
        size = 11.0;
        # draw_bold_text_with_bright_colors = true;
        normal = {
          family = "JetBrainsMono Nerd Font Mono";
          style = "Regular";
        };
      };
      colors = {
        primary = {
          background = "#1d1f21";
          foreground = "#c5c8c6";
        };
        normal = {
          black = "#282a2e";
          red = "#a54242";
          green = "#8c9440";
          yellow = "#de935f";
          blue = "#5f819d";
          magenta = "#85678f";
          cyan = "#5e8d87";
          white = "#707880";
        };
        bright = {
          black = "#373b41";
          red = "#cc6666";
          green = "#b5bd68";
          yellow = "#f0c674";
          blue = "#81a2be";
          magenta = "#b294bb";
          cyan = "#8abeb7";
          white = "#c5c8c6";
        };
      };
    };
  };
}

