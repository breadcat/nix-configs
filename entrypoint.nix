{
  config,
  pkgs,
  lib,
  ...
}: let
  vars = import ./variables.nix { inherit lib; };
  inherit (vars) fullname username domain email sshkey sshport timezone htpasswd vpnusername vpnpassword todosecret privatekey matrixuser matrixserver;

  hostname =
    if builtins.pathExists "/etc/hostname"
    then lib.strings.removeSuffix "\n" (builtins.readFile "/etc/hostname")
    else throw "Error: /etc/hostname not found. Please ensure the hostname is set before rebuild.";

  machine = lib.strings.removeSuffix "\n" hostname;
  osConfigPath = ./machines + "/${machine}.nix";
in {
  imports = [
    (import osConfigPath { inherit config pkgs lib fullname username domain email sshkey sshport timezone htpasswd vpnusername vpnpassword todosecret privatekey machine matrixuser matrixserver ; })
  ];
}