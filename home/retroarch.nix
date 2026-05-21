{ pkgs, ... }:

{
  programs.retroarch = {
    enable = true;
    cores = {
      mesen = {enable = true;};
      parallel-n64 = {enable = true;};
      snes9x = {enable = true;};
      swanstation = {enable = true;};
    };
    # settings = { };
  };
}
