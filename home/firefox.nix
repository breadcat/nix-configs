{ lib, config, ... }:

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
            "browser.ai.control.default" = "blocked"; # ai blocking
            "browser.ai.control.linkPreviewKeyPoints" = "blocked"; # ai blocking
            "browser.ai.control.pdfjsAltText" = "blocked"; # ai blocking
            "browser.ai.control.sidebarChatbot" = "blocked"; # ai blocking
            "browser.ai.control.smartTabGroups" = "blocked"; # ai blocking
            "browser.ai.control.smartWindow" = "blocked"; # ai blocking
            "browser.ai.control.translations" = "blocked"; # ai blocking
            "browser.discovery.containers.enabled" = false; # disable containers
            "browser.ml.linkPreview.enabled" = false; # long press link previews
            "browser.newtab.extensionControlled" = true; # don't warn new tab page has changed
            "browser.newtab.privateAllowed" = true; # hide new tab warning in private too
            "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons" = false; # recommend extensions while I browse
            "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features" = false; # recommend features while I browse
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
          };

          extensions = {
            force = true;
            settings = { "newtaboverride@agenedia.com".settings = { type = "homepage"; focus_website = true; }; };
          };

        };
      };

      policies = {
        DisableFirefoxAccounts = true;
        DisableFirefoxStudies = true;
        DisablePocket = true;
        DisableMasterPasswordCreation = true;
        DisableTelemetry = true;
        ExtensionSettings = {
          "*".installation_mode = "blocked";
          "uBlock0@raymondhill.net" = {
            installation_mode = "force_installed";
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
            private_browsing = true;
            default_area = "menupanel";
            "adminSettings" = builtins.toJSON {
              userSettings = [ [ "prefetchingDisabled" "true" ] ];
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
              # externalLists = ''
              #   https://example.com/my-filter-list.txt
              # '';
            };
          };
          "newtaboverride@agenedia.com" = {
            installation_mode = "force_installed";
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/new-tab-override/latest.xpi";
            private_browsing = true;
            default_area = "menupanel";
          };
          "CookieAutoDelete@kennydo.com" = {
            installation_mode = "force_installed";
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/cookie-autodelete/latest.xpi";
            private_browsing = true;
            default_area = "menupanel";
          };
          "sponsorBlocker@ajay.app" = {
            installation_mode = "force_installed";
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/sponsorblock/latest.xpi";
            private_browsing = true;
            default_area = "menupanel";
          };
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
