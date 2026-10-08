{ lib, config, vars, ... }:

let
  extensions = {
    "uBlock0@raymondhill.net" = "ublock-origin";
    "uMatrix@raymondhill.net" = "umatrix";
    "newtaboverride@agenedia.com" = "new-tab-override";
    "CookieAutoDelete@kennydo.com" = "cookie-autodelete";
    "sponsorBlocker@ajay.app" = "sponsorblock";
  };
in

  {
    programs.firefox = {
      enable = true;
      languagePacks = [ (builtins.replaceStrings [ "_" ".UTF8" ] [ "-" "" ] vars.user.locale) ];
      configPath = "${config.xdg.configHome}/mozilla/firefox";

      profiles = {
        default = {
          id = 0;
          name = "default";
          isDefault = true;

          settings = {
            # sort:start
            "accessibility.browsewithcaret_shortcut.enabled" = false; # disable F7 caret browsing shortcut
            "browser.aboutConfig.showWarning" = false; # disable about:config warning
            "browser.aboutwelcome.enabled" = false; # disable welcome screen
            "browser.ai.control.default" = "blocked"; # ai blocking
            "browser.ai.control.linkPreviewKeyPoints" = "blocked"; # ai blocking
            "browser.ai.control.pdfjsAltText" = "blocked"; # ai blocking
            "browser.ai.control.sidebarChatbot" = "blocked"; # ai blocking
            "browser.ai.control.smartTabGroups" = "blocked"; # ai blocking
            "browser.ai.control.smartWindow" = "blocked"; # ai blocking
            "browser.ai.control.translations" = "blocked"; # ai blocking
            "browser.discovery.containers.enabled" = false; # disable containers
            "browser.download.alwaysOpenPanel" = true; # show downloads when started, even after hiding button
            "browser.gesture.swipe.left" = "cmd_scrollLeft"; # disable trackpad swipe gestures
            "browser.gesture.swipe.right" = "cmd_scrollRight"; # disable trackpad swipe gestures
            "browser.ml.linkPreview.enabled" = false; # long press link previews
            "browser.newtab.extensionControlled" = true; # don't warn new tab page has changed
            "browser.newtab.privateAllowed" = true; # hide new tab warning in private too
            "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons" = false; # recommend extensions while I browse
            "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features" = false; # recommend features while I browse
            "browser.nova.enabled" = false; # disable new ugly gradient themes
            "browser.profiles.enabled" = false; # disable profiles
            "browser.search.suggest.enabled" = false; # disable search suggestions in urlbar
            "browser.sessionstore.resume_from_crash" = false; # don't prompt to restore the previous session on startup
            "browser.startup.couldRestoreSession.count" = "2"; # disable restore tabs on startup banner
            "browser.startup.homepage" = "https://breadcat.github.io/startpage/";
            "browser.tabs.groups.enabled" = false; # disable tab grouping
            "browser.toolbars.bookmarks.visibility" = "never"; # always hide bookmarks bar
            "browser.uiCustomization.state" = builtins.toJSON { placements = { "nav-bar" = [ "back-button" "forward-button" "stop-reload-button" "urlbar-container" ]; "TabsToolbar" = [ "tabbrowser-tabs" ]; }; currentVersion = 26; newElementCount = 0; }; # toolbar layout
            "browser.urlbar.showSearchTerms.enabled" = false; # always show address in address bar
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
            "privacy.reducePageProtection.infobar.enabled.pbmode" = false; # reloading page tracker protecion bar
            # sort:end
          };

          extensions = {
            force = true;
            settings = { "newtaboverride@agenedia.com".settings = { type = "homepage"; focus_website = true; }; };
          };

        };
      };

      policies = {
        # sort:start
        DisableFirefoxAccounts = true;
        DisableFirefoxStudies = true;
        DisableMasterPasswordCreation = true;
        DisablePocket = true;
        DisableTelemetry = true;
        DisplayBookmarksToolbar = "never";
        DontCheckDefaultBrowser = true;
        NewTabPage = false;
        OverrideFirstRunPage = "";
        OverridePostUpdatePage = "";
        PictureInPicture.Enabled = false;
        # sort:end
        EnableTrackingProtection = {
          Value = true;
          Locked = true;
          Cryptomining = true;
          Fingerprinting = true;
        };
        ExtensionSettings = {
          "*".installation_mode = "blocked";
        }

        // lib.mapAttrs
        (_id: addon: {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/${addon}/latest.xpi";
          installation_mode = "force_installed"; private_browsing = true; default_area = "menupanel";
        })
        extensions;

        "3rdparty".Extensions."uBlock0@raymondhill.net".adminSettings = {
          selectedFilterLists = [
            "ublock-filters"
            "ublock-badware"
            "ublock-privacy"
            "ublock-unbreak"
            "easylist"
            "easyprivacy"
            "plowe-0"
            "fanboy-cookiemonster"
            "ublock-cookies-easylist"
            "adguard-cookies"
            "ublock-annoyances"
          ];

        };
        UserMessaging = {
          "ExtensionRecommendations" = false;
          "FeatureRecommendations" = false;
          "UrlbarInterventions" = false;
          "FirefoxLabs" = false;
          "MoreFromMozzilla" = false;
          "SkipOnboarding" = true;
          "Locked" = true;
        };
      };
    };

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
