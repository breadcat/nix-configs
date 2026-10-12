{ lib, machine, vars, ... }:

let
  hmVersion = (import ../variables.nix { inherit lib; }).hm-version;
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-${hmVersion}.tar.gz";
in

{
  imports = [ (import "${home-manager}/nixos") ];

  home-manager = {
    backupFileExtension = "hm-bak";
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit machine vars; };
  };
}
