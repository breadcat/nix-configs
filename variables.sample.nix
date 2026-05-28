{ lib }:

rec {
  user = rec {
    fullname = "Peter";
    username = lib.strings.toLower fullname;
    domain = "domain.com";
    email = "${username}@${domain}";
    timezone = "Europe/London";
    postcode = "AA1 1AA";
    address = "123 Fake Street\n${postcode}\n${postcode}";
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
    };
  matrix = {
    user = "@user:domain.com";
    homeserver = "https://matrix.domain.com";
    };
}