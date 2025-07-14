{
  config,
  pkgs,
  lib,
  ...
}: let
  fullname = "Peter";
  username = lib.strings.toLower fullname;
  domain = "minskio.co.uk";
  email = "${username}@${domain}";
  sshkey = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCXdHG4d/CoCbS1mp7cg+/3qS8nI4bvp7nvU5BZdkzseOt1NerZ4rgdQLBiFGiEi4LPMOQxBGXe7uuskn3TCc2C/DkZH/+AdYQ5MDXRbRqta/0oS8XVTzWcBtluaHc6qsuF6MkSU853ZWVgzlYimfSkjkwvrMT38WkkauC9U4VoqODVLQe5sivR/2INHctNfj0dYuyvPRUhAiuTrha0cKrS7xkOIf4a9gQgunU4+cmyb1HPt6KmNMzuZ/nhsqVWf6h/v0oBTg8p+aestfpg2fTAlY8Za8t/ZOqpF1TeWqUB+1AXEoQHNw2bezzKwCyX39cvjTeE5EWKl7oXalq91J39 ssh-key-2022-02-16";
  hostname =
    if builtins.pathExists "/etc/hostname"
    then lib.strings.removeSuffix "\n" (builtins.readFile "/etc/hostname")
    else throw "Error: /etc/hostname not found. Please ensure the hostname is set before rebuild.";
  machine = lib.strings.removeSuffix "\n" hostname;
  osConfigPath = ./machines + "/${machine}.nix";
in {
  imports = [
    (import osConfigPath {inherit config pkgs lib fullname machine username domain email sshkey;})
  ];

  networking.hostName = machine;
}
