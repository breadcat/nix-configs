{ lib, machine, ... }:

{
  networking = {
    hostName = machine;
    networkmanager.enable = true;
    useDHCP = lib.mkDefault true;
  };
}


