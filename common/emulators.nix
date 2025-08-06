{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # Emulators
    blastem
    cemu
    dolphin-emu
    duckstation
    flycast
    gopher64
    melonDS
    mgba
    pcsx2
    ppsspp
    punes
    rpcs3
    sameboy
    snes9x
    xemu
    # Game engines
    corsix-th
    eduke32
    openra
    openrct2
    openttd
  ];
}
