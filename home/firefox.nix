{ config, pkgs, ... }:

{
  programs.firefox = {
    enable = true;

    profiles = {
      default = {
        id = 0;
        name = "default";
        isDefault = true;

        settings = {
          "browser.aboutConfig.showWarning" = false;
          "browser.ml.linkPreview.enabled" = false; # long press link previews
          "browser.newtab.extensionControlled" = true; # don't warn new tab page has changed
          "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons" = false; # recommend extensions while I browse
          "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features" = false; # recommend features while I browse
          "browser.startup.couldRestoreSession.count" = "-1"; # restore tabs on startup banner
          "browser.startup.homepage" = "https://breadcat.github.io/startpage/";
          "extensions.activeThemeID" = "firefox-compact-dark@mozilla.org";
          "extensions.autoDisableScopes" = 0; # enable extensions by default
          "general:autoScroll" = true; # middle mouse page scroll instead of paste
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
