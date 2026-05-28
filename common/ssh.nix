{ vars, ... }:

{
  # SSH service
  services.openssh = {
    enable = true;
    ports = [ vars.secrets.sshport ];
    settings.PasswordAuthentication = false;
  };
  # Fail2ban service
  services.fail2ban.enable = true;
  # Import SSH key
  users.users.${vars.user.username}.openssh.authorizedKeys.keys = [ "${vars.secrets.sshkey}" ];

}
