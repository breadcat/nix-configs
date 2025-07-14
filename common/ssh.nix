{ username, sshkey, ... }:

{
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    };

  # SSH key
  users.users.${username}.openssh.authorizedKeys.keys = [ "${sshkey}" ];
}