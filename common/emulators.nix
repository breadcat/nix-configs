{ pkgs, ... }:

let
  retroarchWithCores = (
    pkgs.retroarch.withCores (
      cores: with cores; [
      beetle-saturn
      # cemu
      dolphin
      flycast
      genesis-plus-gx
      # gopher64
      melonds
      mesen
      mgba
      parallel-n64
      pcsx2
      ppsspp
      # rpcs3
      sameboy
      snes9x
      swanstation
      # xemu
      # Game engines: corsix-th, eduke32, openra, openrct2, openttd
      # Frontends: pegasus-frontend
      # Tools: mame-tools, moonlight-qt
      ]
    )
  );
in
{
  environment.systemPackages = [ retroarchWithCores ];
}
