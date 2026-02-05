{ pkgs, ... }:

{
  home.packages = with pkgs; [ github-desktop libsecret ];

  services.gnome-keyring = {
    enable = true;
    components = ["pkcs11" "secrets" "ssh"];
  };

  # firefox URL handlers
  programs.firefox.profiles.default.settings = {
    "network.protocol-handler.expose.x-github-desktop-dev-auth" = false;
    "network.protocol-handler.external.x-github-desktop-dev-auth" = true;
    "network.protocol-handler.warn-external.x-github-desktop-dev-auth" = false;
    };

}
