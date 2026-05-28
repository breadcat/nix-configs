{ pkgs, vars, ... }:
{
  users.users."${vars.user.username}" = {
    isNormalUser = true;
    description = "${vars.user.fullname}";
    shell = pkgs.fish;
    extraGroups = [ "networkmanager" "wheel" "video" "input" ];
  };

  # Enable fish shell, and for nix-shell
  programs.fish.enable = true;
  programs.fish.interactiveShellInit = ''
    ${pkgs.any-nix-shell}/bin/any-nix-shell fish --info-right | source
  '';
}
