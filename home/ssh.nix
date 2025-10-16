{ domain, username, sshport, privatekey, ... }:

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
        hostname = "${domain}";
        user = "${username}";
        port = sshport;
        identityFile = "${privatekey}";
        extraOptions = {
          RemoteCommand = "ssh -p 55013 ${username}@localhost -i ${privatekey}";
          RequestTTY = "force";
          };
      };
      "arcadia" = {
        hostname = "192.168.1.6";
        user = "${username}";
        port = sshport;
        identityFile = "${privatekey}";
      };
      "ilias" = {
        hostname = "192.168.1.3";
        user = "${username}";
        port = sshport;
        identityFile = "${privatekey}";
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
        hostname = "${domain}";
        user = "${username}";
        port = sshport;
        identityFile = "${privatekey}";
      };
    };
  };

}
