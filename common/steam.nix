{ pkgs, ... }:

{
  programs = {
    gamemode.enable = true;
    steam.enable = true;
    steam.gamescopeSession.enable = true;
  };

  environment.systemPackages = with pkgs; [
    # sort:start
    heroic
    mangohud
    protontricks
    protonup-rs
    # sort:end
  ];

  environment.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS =
      "\${HOME}/.steam/root/compatibilitytools.d";
  };

}
