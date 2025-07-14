{ pkgs, username, fullname, ... }:
{
  users.users."${username}" = {
    isNormalUser = true;
    description = "${fullname}";
    shell = pkgs.fish;
    extraGroups = [ "networkmanager" "wheel" "video" ];
  };

  # Auto login
  services.getty.autologinUser = "${username}";

  # Enable fish shell
  programs.fish.enable = true;
}
