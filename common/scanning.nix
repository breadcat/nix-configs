{ vars, ... }:

{
  hardware.sane.enable = true;
  users.users."${vars.user.username}".extraGroups = [ "scanner" ];
}
