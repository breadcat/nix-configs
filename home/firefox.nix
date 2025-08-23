{ config, pkgs, ... }:

let
  nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") { inherit pkgs; };
in
{
  # Enable Firefox via Home Manager
  programs.firefox = {
    enable = true;
    languagePacks = [ "en-GB" ];

    profiles.default = {
      name = "default";
      isDefault = true;

      extensions.packages = with nur.repos.rycee.firefox-addons; [
        ublock-origin
        cookie-autodelete
        new-tab-override
      ];

      settings = {
        "browser.aboutConfig.showWarning" = false;
        "browser.gesture.swipe.left" = "cmd_scrollLeft";
        "browser.gesture.swipe.right" = "cmd_scrollRight";
        "browser.startup.homepage" = "https://breadcat.github.io/startpage/";
        "browser.theme.content-theme" = "0"; # Dark theme
        "browser.theme.toolbar-theme" = "0"; # Dark theme
        "browser.toolbars.bookmarks.visibility" = "never";
        "extensions.pocket.enabled" = false;
        "general:autoScroll" = true;
        "layout.css.prefers-color-scheme.content-override" = "0"; # Dark CSS themes
        "network.cookie.cookieBehavior" = 1; # Block third-party cookies
        "privacy.donottrackheader.enabled" = true;
      };
    };

    policies = {
      DisableTelemetry = true;
      DisablePocket = true;
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
      };
    };
  };

home.sessionVariables = {
	BROWSER = "firefox";
	MOZ_ENABLE_WAYLAND = 1;
};
}
