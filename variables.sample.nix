{ lib }:

let
  fullname = "Peter";
  username = lib.strings.toLower fullname;
  domain = "domain.com";
  email = "${username}@${domain}";
  sshkey = "ssh-rsa yourpubkeyhere";
  sshport = 2222;
  timezone = "Europe/London";
  htpasswd = ""; # caddy hash-password --plaintext "yourpassword" | base64 -w0
  vpnusername = "";
  vpnpassword = "";
  todosecret = "JWTtoken";
  privatekey = "path/to/private.key";
in {
  inherit fullname username domain email sshkey sshport timezone vpnusername vpnpassword todosecret privatekey;
}