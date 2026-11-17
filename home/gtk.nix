{ pkgs, ... }:

{
  home.pointerCursor = {
    gtk.enable = true;
    hyprcursor.enable = true;
    package = pkgs.posy-cursors;
    name = "Posy_Cursor_Black";
    size = 24;
  };
  gtk = {
    enable = true;
    colorScheme = "dark";
    gtk2.enable = false;
    gtk3.enable = true;
    gtk4.enable = true;
  };
}
