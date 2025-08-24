{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # Emulators
    # blastem
    # cemu
    # dolphin-emu
    # duckstation
    # flycast
    # gopher64
    # melonDS
    # mesen
    # mgba
    # pcsx2
    # ppsspp
    # rpcs3
    # sameboy
    # snes9x
    # xemu
    # Game engines
    # corsix-th
    # eduke32
    # openra
    # openrct2
    # openttd
    # Frontend
    # pegasus-frontend
    # Tools
    # mame-tools
    # moonlight-qt
  ];
}
