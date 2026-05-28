{ vars, ... }:

{
  services.getty.autologinUser = "${vars.user.username}";
}
