{ username, ... }:

{
  programs.kodi = {
    enable = true;
      settings = {
        "addons.unknownsources" = "true";
        "addons.updatemode" = "1";
        "locale.country" = "UK (12h)";
        "locale.language" = "resource.language.en_gb";
        "locale.timezone" = "Europe/London";
        "locale.timezonecountry" = "Britain (UK)";
        "lookandfeel.skincolors" = "midnight";
        "screensaver.mode" = "screensaver.xbmc.builtin.dim";
        "screensaver.time" = "5";
        "services.webserver" = "true";
        "services.webserverauthentication" = "true";
        "services.webserverpassword" = "kodi";
        "services.webserverport" = "8080";
        "services.webserverusername" = "kodi";
        "videolibrary.tvshowsselectfirstunwatcheditem" = "2";
        };
      addonSettings = {
        "service.watchedlist" = {
	  "extdb" = "true";
          "dbpath" = "/home/${username}/vault/";
          "dbfilename" = "watchedlist.db";
          };
        "skin.estuary" = {
          "homemenunopicturesbutton" = "true";
          "homemenunoradiobutton" = "true";
          "homemenunofavbutton" = "true";
          "homemenunomusicbutton" = "true";
          "homemenunomusicvideobutton" = "true";
          "homemenunovideosbutton" = "true";
          "homemenunotvbutton" = "true";
          };
        };
      sources = {
        video = {
          default = "movies";
          source = [
            { name = "television"; path = "/tank/media/videos/television"; allowsharing = "true"; }
            { name = "movies"; path = "/tank/media/videos/movies"; allowsharing = "true"; }
            { name = "${username}"; path = "/home/${username}"; allowsharing = "true"; }
            ];
		  };
		  files = {
		    source = [
		      { name = "a4kSubtitles-repo"; path = "https://a4k-openproject.github.io/a4kSubtitles/packages/"; allowsharing = "true"; }
		      ];
		    };
		  };
		};
  # Launch Kodi via Hyprland
  wayland.windowManager.hyprland = {
    settings = {
      "exec-once" = "kodi";
    };
  };
}
