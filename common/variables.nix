{ machine, fullname, username, domain, email, sshkey, sshport, timezone, postcode, address, htpasswd, vpnusername, vpnpassword, todosecret, pdfpassword, privatekey, matrixuser, matrixserver }:

let
  all-variables = { inherit machine fullname username domain email sshkey sshport timezone postcode address htpasswd vpnusername vpnpassword todosecret pdfpassword privatekey matrixuser matrixserver; };
in

{
  _module.args = all-variables;
}
