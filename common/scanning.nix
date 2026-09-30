{ vars, ... }:

{
  imports = [ ../scripts/scan-to-pdf.nix ];
  hardware.sane.enable = true;
  users.users."${vars.user.username}".extraGroups = [ "scanner" ];
}
