{ pkgs, ... }:

{
  programs = {
    gamemode.enable = true;
    steam.enable = true;
    steam.gamescopeSession.enable = true;
  };

  environment.systemPackages = with pkgs; [
    mangohud
    protonup-rs
    protontricks
  ];

  environment.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS =
      "\${HOME}/.steam/root/compatibilitytools.d";
  };

}
