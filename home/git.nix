{ vars, pkgs, ... }:

{
  programs.git = {
    enable = true;
    settings = {
      user.name = "${vars.user.fullname}";
      user.email = "${vars.user.email}";
      credential.helper = "!gh auth git-credential"; # gh auth login
    };
  };
  home.packages = with pkgs; [ gh ];
}
