{ lib, ... }:

let
  nixbootExists = builtins.pathExists "/dev/disk/by-label/NIXBOOT";
  tankExists = builtins.pathExists "/dev/disk/by-label/TANK";
in
{
  fileSystems = lib.mkMerge [

    {
      "/" = {
        device = "/dev/disk/by-label/NIXROOT";
        fsType = "ext4";
      };
    }

    # Conditionally include filesystems
    (lib.mkIf nixbootExists {
      "/boot" = {
        device = "/dev/disk/by-label/NIXBOOT";
        fsType = "vfat";
      };
    })
    (lib.mkIf tankExists {
      "/tank" = {
        device = "/dev/disk/by-label/TANK";
        fsType = "ext4";
      };
    })
  ];
}
