{ username, sshkey, sshport, ... }:

{
  # SSH service
  services.openssh = {
    enable = true;
    ports = [ sshport ];
    settings.PasswordAuthentication = false;
  };
  # Fail2ban service
  services.fail2ban.enable = true;
  # Import SSH key
  users.users.${username}.openssh.authorizedKeys.keys = [ "${sshkey}" ];

}
