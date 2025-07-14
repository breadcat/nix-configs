{ domain, username, ... }:

{
	programs.ssh = {
		enable = true;

		matchBlocks = {
			"minskio" = {
				hostname = "${domain}";
				user = "${username}";
				port = 55012;
				identityFile = "~/vault/docs/secure/ssh-key-2022-02-16.key";
			};
			"tunnel" = {
				hostname = "${domain}";
				user = "${username}";
				port = 55012;
				identityFile = "~/vault/docs/secure/ssh-key-2022-02-16.key";
				extraOptions = {
					RemoteCommand = "ssh -p 55013 ${username}@localhost -i ~/vault/docs/secure/ssh-key-2022-02-16.key";
					RequestTTY = "force";
					};
			};
			"htpc" = {
				hostname = "192.168.1.6";
				user = "${username}";
				port = 22;
				identityFile = "~/vault/docs/secure/ssh-key-2022-02-16.key";
			};
			"nas" = {
				hostname = "192.168.1.3";
				user = "${username}";
				port = 22;
				identityFile = "~/vault/docs/secure/ssh-key-2022-02-16.key";
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
		};
	};

}
