{pkgs, ...}: let
  htpc-launcher = pkgs.writeShellScriptBin "htpc-launcher" ''
    kodi &
    sleep 4
    kodi-send -a toggleFullscreen
    sleep 1
    kodi-send -a toggleFullscreen
  '';
in {
  environment.systemPackages = [htpc-launcher];
}
