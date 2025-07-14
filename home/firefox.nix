{
programs.firefox = {
  enable = true;

  profiles.default = {
    id = 0;
    name = "default";

    # Example Firefox preferences
    settings = {
      "browser.aboutConfig.showWarning" = false;
      "browser.gesture.swipe.left" = "";
      "browser.gesture.swipe.right" = "";
      "browser.startup.homepage" = "https://breadcat.github.io/startpage/";
      "browser.theme.content-theme" = "0"; # Dark theme
      "browser.theme.toolbar-theme" = "0"; # Dark theme
      "layout.css.prefers-color-scheme.content-override" = "0"; # Dark CSS themes
      "network.cookie.cookieBehavior" = 1; # Block third-party cookies
      "privacy.donottrackheader.enabled" = true;
    };
    extensions = [
      # "ublock-origin@raymondhill.net"  # Just an example (must match extension ID)
      # "uBlock0@raymondhill.net" # uBlock Origin
    ];
  };
};
home.sessionVariables = {
	MOZ_ENABLE_WAYLAND = 1;
};
}