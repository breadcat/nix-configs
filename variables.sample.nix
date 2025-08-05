{ lib }:

let
  fullname = "Peter";
  username = lib.strings.toLower fullname;
  domain = "domain.com";
  email = "${username}@${domain}";
  sshkey = "ssh-rsa yourkeyhere";
  sshport = 2222;
  timezone = "Europe/London";
  htpasswd = "";
  vpnusername = "";
  vpnpassword = "";
  todosecret = "";
in {
  inherit fullname username domain email sshkey sshport timezone vpnusername vpnpassword todosecret;
}