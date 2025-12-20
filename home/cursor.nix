{ pkgs, ... }:

{
home.pointerCursor = {
  gtk.enable = true;
  package = pkgs.posy-cursors;
  name = "Posy_Cursor_Black";
  size = 24;
};
}
