{ config, vars, pkgs, ... }:

{
  programs.kodi = {
    enable = true;
    package = pkgs.kodi-wayland.withPackages (kodiPkgs: with kodiPkgs; [
      a4ksubtitles
      inputstream-adaptive
      sendtokodi
      sponsorblock
      upnext
      youtube
    ]);
    addonSettings = {
      "plugin.video.youtube" = { "kodion.video.quality" = "3"; "kodion.setup_wizard" = "false"; };
      "service.subtitles.a4ksubtitles" = { "opensubtitles.enabled" = "false"; };
      "service.upnext" = { "stopAfterClose" = "true"; "enablePlaylist" = "true"; "includeWatched" = "true";};
      "service.watchedlist" = { "extdb" = "true"; "dbpath" = "/home/${vars.user.username}/vault/"; "dbfilename" = "watchedlist.db"; };
      };
      sources = {
      video = {
      default = "movies";
      source = [
      { name = "${vars.user.username}"; path = "/home/${vars.user.username}"; allowsharing = "true"; }
      { name = "movies"; path = "/tank/media/videos/movies"; allowsharing = "true"; }
      { name = "seedbox"; path = "/home/${vars.user.username}/seedbox"; allowsharing = "true"; }
      { name = "television"; path = "/tank/media/videos/television"; allowsharing = "true"; }
      ];
      };
      };
      };
      home.file.".kodi/userdata/guisettings.xml" = {
        force = true;
        text = ''
          <settings version="2">
          <setting id="addons.unknownsources">true</setting>
          <setting id="addons.updatemode">1</setting>
          <setting id="locale.country">UK (12h)</setting>
          <setting id="locale.language">resource.language.en_gb</setting>
          <setting id="locale.timezone">${vars.user.timezone}</setting>
          <setting id="locale.timezonecountry">Britain (UK)</setting>
          <setting id="lookandfeel.skincolors">midnight</setting>
          <setting id="screensaver.mode">screensaver.xbmc.builtin.dim</setting>
          <setting id="screensaver.time">5</setting>
          <setting id="services.webserver">true</setting>
          <setting id="services.webserverauthentication">true</setting>
          <setting id="services.webserverpassword">kodi</setting>
          <setting id="services.webserverport">8080</setting>
          <setting id="services.webserverusername">kodi</setting>
          <setting id="videolibrary.tvshowsselectfirstunwatcheditem">2</setting>
          </settings>
        '';
      };
      home.file.".kodi/userdata/addon_data/skin.estuary/settings.xml".text = ''
        <settings version="2">
        <setting id="background_overlay" type="string">4</setting>
        <setting id="homemenunogamesbutton" type="bool">true</setting>
        <setting id="homemenunomusicbutton" type="bool">true</setting>
        <setting id="homemenunomusicvideobutton" type="bool">true</setting>
        <setting id="homemenunopicturesbutton" type="bool">true</setting>
        <setting id="homemenunoradiobutton" type="bool">true</setting>
        <setting id="homemenunotvbutton" type="bool">true</setting>
        <setting id="homemenunovideosbutton" type="bool">true</setting>
        <setting id="homemenunoweatherbutton" type="bool">true</setting>
        <setting id="no_slide_animations" type="bool">true</setting>
        </settings>
      '';
      home.file.".kodi/userdata/favourites.xml".text = ''
        <favourites>
        <!-- sort:start -->
        <favourite name="EndlessBBT">ActivateWindow(10025,"special://profile/playlists/video/EndlessBBT.xsp",return)</favourite>
        <favourite name="Moonlight">System.Exec("moonlight")</favourite>
        <favourite name="Retroarch">System.Exec("retroarch")</favourite>
        <favourite name="Seedbox">ActivateWindow(10502,"/home/${vars.user.username}/seedbox/",return)</favourite>
        <favourite name="Spotify">System.Exec("alacritty -e spotify_player")</favourite>
        <!-- sort:end -->
        </favourites>
      '';
      home.file.".kodi/userdata/playlists/video/EndlessBBT.xsp".text = ''
        <?xml version="1.0" encoding="UTF-8" standalone="yes" ?>
        <smartplaylist type="episodes"><name>EndlessBBT</name>
        <match>all</match><limit>25</limit><order direction="ascending">random</order>
        <rule field="tvshow" operator="is"><value>The Big Bang Theory</value></rule>
        </smartplaylist>
      '';

  # Launch Kodi via Hyprland
  wayland.windowManager.hyprland.extraConfig = ''
    hl.on("hyprland.start",function()hl.exec_cmd("${pkgs.coreutils}/bin/env TZDIR=/etc/zoneinfo TZ=${vars.user.timezone} ${config.programs.kodi.package}/bin/kodi")end)
  '';

}
