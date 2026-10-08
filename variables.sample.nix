{ lib }:

rec {
  user = rec {
    fullname = "Peter";
    username = lib.strings.toLower fullname;
    domain = "domain.com";
    email = "${username}@${domain}";
    timezone = "Europe/London";
    locale = "en_GB.UTF-8";
    address = "${addr.number} ${addr.street}\n${addr.town}\n${addr.county}\n${addr.postcode}";
    addr = {
      number = "123";
      street = "Fake Street";
      town = "Faketown";
      county = "North Fakesburg";
      postcode = "AB1 1CD";
    };
    };
  secrets = {
    sshkey = "ssh-rsa yourpubkeyhere";
    sshport = 2222;
    htpasswd = "caddy hash-password --plaintext "yourpassword" | base64 -w0";
    vpnusername = "";
    vpnpassword = "";
    todosecret = "";
    pdfpassword = "";
    privatekey = "path/to/private.key";
    zerotier = "";
    cloudflare = "";
    };
  syncthing = {
    machine1 = "id-number-1";
    machine2 = "id-number-2";
    };
}
