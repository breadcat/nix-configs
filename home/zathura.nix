{ pkgs, ... }:

{
  programs.zathura = {
    enable = true;

    package = pkgs.zathura.override {
      plugins = with pkgs.zathuraPkgs; [
        zathura_pdf_mupdf
        zathura_cb
      ];
    };

    options = {
      adjust-open = "best-fit";
      pages-per-row = 1;
      selection-clipboard = "clipboard";
      statusbar-basename = true;
      scroll-page-aware = true;
      scroll-step = 100;
      guioptions = "s";
      font = "monospace normal 10";
      # colour scheme
      default-bg = "#202020";
      default-fg = "#D0D0D0";
      statusbar-bg = "#181818";
      statusbar-fg = "#B8B8B8";
      inputbar-bg = "#181818";
      inputbar-fg = "#D0D0D0";
      notification-bg = "#303030";
      notification-fg = "#D0D0D0";
      notification-error-bg = "#402020";
      notification-error-fg = "#E0B0B0";
      notification-warning-bg = "#403820";
      notification-warning-fg = "#E0D0A0";
      highlight-color = "#606060";
      highlight-active-color = "#888888";
      # recolour scheme
      recolor = false;
      recolor-lightcolor = "#202020";
      recolor-darkcolor = "#D0D0D0";
      recolor-keephue = true;
    };

    mappings = {
      "h" = "scroll left";
      "j" = "scroll down";
      "k" = "scroll up";
      "l" = "scroll right";
      "<Space>" = "scroll down";
      "<S-Space>" = "scroll up";
      "<C-d>" = "scroll half-down";
      "<C-u>" = "scroll half-up";
      "gg" = "goto top";
      "G" = "goto bottom";
      "+" = "zoom in";
      "-" = "zoom out";
      "=" = "zoom in";
      "i" = "adjust_window width";
      "o" = "adjust_window best-fit";
      "r" = "rotate";
      "<C-r>" = "recolor";
      "<C-f>" = "toggle_fullscreen";
      "q" = "quit";
    };
  };
}
