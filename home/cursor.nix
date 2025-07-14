{ pkgs, lib, ... }:

{
home.pointerCursor = {
  gtk.enable = true;
  package = pkgs.posy-cursors;
  name = "Posy_Cursor_Black";
  size = 24;
};

nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
             "posy-cursors"
           ];
         }
	 
