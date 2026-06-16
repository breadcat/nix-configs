{ vars, ... }:

{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings = {
      "*" = {
        ForwardAgent = false;
        AddKeysToAgent = "no";
        Compression = false;
        ServerAliveInterval = 0;
        ServerAliveCountMax = 3;
        HashKnownHosts = false;
        UserKnownHostsFile = "~/.ssh/known_hosts";
        ControlMaster = "no";
        ControlPath = "~/.ssh/master-%r@%n:%p";
        ControlPersist = "no";
      };
      "tunnel" = {
        HostName = vars.user.domain;
        User = vars.user.username;
        Port = vars.secrets.sshport;
        IdentityFile = vars.secrets.privatekey;
        RemoteCommand = "ssh -p 55013 ${vars.user.username}@localhost -i ${vars.secrets.privatekey}";
        RequestTTY = "force";
      };
      "arcadia" = {
        HostName = "192.168.1.6";
        User = vars.user.username;
        Port = vars.secrets.sshport;
        IdentityFile = vars.secrets.privatekey;
      };
      "ilias" = {
        HostName = "192.168.1.3";
        User = vars.user.username;
        Port = vars.secrets.sshport;
        IdentityFile = vars.secrets.privatekey;
      };
      "router" = {
        HostName = "192.168.1.1";
        User = "root";
        Port = 22;
      };
      "ap" = {
        HostName = "192.168.1.2";
        User = "root";
        Port = 22;
      };
      "artemis" = {
        HostName = vars.user.domain;
        User = vars.user.username;
        Port = vars.secrets.sshport;
        IdentityFile = vars.secrets.privatekey;
      };
    };
  };
}
