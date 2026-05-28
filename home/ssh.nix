{ vars, ... }:

{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks = {
    "*" = {
        forwardAgent = false;
        addKeysToAgent = "no";
        compression = false;
        serverAliveInterval = 0;
        serverAliveCountMax = 3;
        hashKnownHosts = false;
        userKnownHostsFile = "~/.ssh/known_hosts";
        controlMaster = "no";
        controlPath = "~/.ssh/master-%r@%n:%p";
        controlPersist = "no";
      };
      "tunnel" = {
        hostname = "${vars.user.domain}";
        user = "${vars.user.username}";
        port = vars.secrets.sshport;
        identityFile = "${vars.secrets.privatekey}";
        extraOptions = {
          RemoteCommand = "ssh -p 55013 ${vars.user.username}@localhost -i ${vars.secrets.privatekey}";
          RequestTTY = "force";
          };
      };
      "arcadia" = {
        hostname = "192.168.1.6";
        user = "${vars.user.username}";
        port = vars.secrets.sshport;
        identityFile = "${vars.secrets.privatekey}";
      };
      "ilias" = {
        hostname = "192.168.1.3";
        user = "${vars.user.username}";
        port = vars.secrets.sshport;
        identityFile = "${vars.secrets.privatekey}";
      };
      "router" = {
        hostname = "192.168.1.1";
        user = "root";
        port = 22;
      };
      "ap" = {
        hostname = "192.168.1.2";
        user = "root";
        port = 22;
        extraOptions = {
          HostKeyAlgorithms = "+ssh-rsa";
          };
      };
      "artemis" = {
        hostname = "${vars.user.domain}";
        user = "${vars.user.username}";
        port = vars.secrets.sshport;
        identityFile = "${vars.secrets.privatekey}";
      };
    };
  };

}
