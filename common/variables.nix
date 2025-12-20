{ machine, fullname, username, domain, email, sshkey, sshport, timezone, postcode, address, htpasswd, vpnusername, vpnpassword, todosecret, privatekey, matrixuser, matrixserver }:

let
  all-variables = { inherit machine fullname username domain email sshkey sshport timezone postcode address htpasswd vpnusername vpnpassword todosecret privatekey matrixuser matrixserver; };
in

{
  _module.args = all-variables;
}
