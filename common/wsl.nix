{ vars, ... }:

{
  wsl = {
    enable = true;
    # https://discourse.nixos.org/t/set-default-user-in-wsl2-nixos-distro/38328/8
    defaultUser = vars.user.username;
    };
}
