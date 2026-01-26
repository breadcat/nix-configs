{ pkgs, username, fullname, ... }:
{
  users.users."${username}" = {
    isNormalUser = true;
    description = "${fullname}";
    shell = pkgs.fish;
    extraGroups = [ "networkmanager" "wheel" "video" "input" ];
  };

  # Enable fish shell, and for nix-shell
  programs.fish.enable = true;
  programs.fish.interactiveShellInit = ''
    ${pkgs.any-nix-shell}/bin/any-nix-shell fish --info-right | source
  '';
}
