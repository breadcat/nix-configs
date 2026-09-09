{ config, pkgs, ... }:

{
  programs.firefox = {
    enable = true;
    configPath = "${config.xdg.configHome}/mozilla/firefox";

    profiles = {
      default = {
        id = 0;
        name = "default";
        isDefault = true;

        settings = {
          "browser.aboutConfig.showWarning" = false; # disable about:config warning
          "browser.aboutwelcome.enabled" = false; # disable welcome screen
          "browser.discovery.containers.enabled" = false; # disable containers
          "browser.ml.linkPreview.enabled" = false; # long press link previews
          "browser.newtab.extensionControlled" = true; # don't warn new tab page has changed
          "browser.newtab.privateAllowed" = true; # hide new tab warning in private too
          "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons" = false; # recommend extensions while I browse
          "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features" = false; # recommend features while I browse
          "browser.search.suggest.enabled" = false; # disable search suggestions in urlbar
          "browser.sessionstore.resume_from_crash" = false; # don't prompt to restore the previous session on startup
          "browser.startup.couldRestoreSession.count" = "2"; # disable restore tabs on startup banner
          "browser.startup.homepage" = "https://breadcat.github.io/startpage/";
          "browser.tabs.groups.enabled" = false; # disable tab grouping
          "browser.toolbars.bookmarks.visibility" = "never"; # always hide bookmarks bar
          "browser.urlbar.suggest.quicksuggest.all" = false; # disable suggestions in urlbar
          "browser.urlbar.suggest.quicksuggest.sponsored" = false; # disable sponsored suggestions in urlbar
          "extensions.activeThemeID" = "firefox-compact-dark@mozilla.org";
          "extensions.autoDisableScopes" = 0; # enable extensions by default
          "extensions.formautofill.creditCards.enabled" = false; # disable credit card saving
          "general.autoScroll" = true; # middle mouse page scroll instead of paste
          "media.videocontrols.picture-in-picture.enabled" = false; # disable pip entirely
          "media.videocontrols.picture-in-picture.video-toggle.enabled" = false; # disable pip popup
          "media.webspeech.synth.dont_notify_on_error" = true; # disable speech errors
          "media.webspeech.synth.enabled" = false; # disable speech entirely
        };

        extensions = {
          packages = with pkgs.nur.repos.rycee.firefox-addons; [
            cookie-autodelete
            new-tab-override
            ublock-origin
          ];

        };

      };
    };

    policies = {
      DisableFirefoxAccounts = true;
      DisableFirefoxStudies = true;
      DisablePocket = true;
      DisableTelemetry = true;
    };
  };


  wayland.windowManager.hyprland.extraConfig = ''
    hl.bind("SUPER + W", hl.dsp.exec_cmd("firefox"))
    hl.bind("SUPER + SHIFT + W", hl.dsp.exec_cmd("firefox -private-window"))
  '';

  home.sessionVariables = {
    BROWSER = "firefox";
    MOZ_ENABLE_WAYLAND = 1;
  };

  xdg.mimeApps.defaultApplications = {
    "text/html" = ["firefox.desktop"];
    "text/xml" = ["firefox.desktop"];
    "x-scheme-handler/http" = ["firefox.desktop"];
    "x-scheme-handler/https" = ["firefox.desktop"];
  };

}
