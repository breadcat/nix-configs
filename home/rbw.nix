{ pkgs, vars, ... }:

{
  programs.rbw = {
    enable = true;
    settings = {
      base_url = "https://pass.${vars.user.domain}";
      email = "${vars.user.email}";
      pinentry = pkgs.pinentry-tty;
      };
  };
}

