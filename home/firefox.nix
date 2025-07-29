{
programs.firefox = {
  enable = true;
  profiles.default = {
    id = 0;
    name = "default";
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
    extensions = [
    ];
  };
};
home.sessionVariables = {
	MOZ_ENABLE_WAYLAND = 1;
};
}