{ username, sshkey, ... }:

{
  # SSH service
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    };
  # Fail2ban service
  services.fail2ban.enable = true;
  # Import SSH key
  users.users.${username}.openssh.authorizedKeys.keys = [ "${sshkey}" ];

}