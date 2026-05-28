{ machine, fullname, username, domain, email, sshkey, sshport, timezone, postcode, address, htpasswd, vpnusername, vpnpassword, todosecret, pdfpassword, privatekey, matrixuser, matrixserver }:

let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-25.11.tar.gz";
  all-variables = { inherit machine fullname username domain email sshkey sshport timezone postcode address htpasswd vpnusername vpnpassword todosecret pdfpassword privatekey matrixuser matrixserver; };
in

{
  imports = [ (import "${home-manager}/nixos") ];

  home-manager = {
    backupFileExtension = "hm-bak";
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = all-variables;
  };
}
