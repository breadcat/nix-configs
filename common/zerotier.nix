{ vars, ... }:

{
  services.zerotierone = {
    enable = true;
    joinNetworks = [ "${vars.secrets.zerotier}" ];
  };

  networking.firewall.trustedInterfaces = [ "zt+" ];
}
