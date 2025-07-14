{ pkgs, domain, email, ... }:

{
  programs.rbw = {
    enable = true;
    settings = {
      base_url = "https://pass.${domain}";
      email = "${email}";
      pinentry = pkgs.pinentry-tty;
      };
  };
}

