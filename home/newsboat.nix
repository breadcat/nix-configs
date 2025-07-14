{ domain, username, ... }:

{
  programs.newsboat = {
    enable = true;
    extraConfig = ''
      show-read-feeds no
      auto-reload yes
      reload-time 45
      browser $BROWSER
      bind-key RIGHT open
      bind-key LEFT quit
      bind-key a toggle-article-read
      bind-key m toggle-show-read-feeds
      bind-key n next-unread
      bind-key N prev-unread
      macro m set browser "mpv %u" ; open-in-browser-and-mark-read ; set browser "$BROWSER %u"
      urls-source "freshrss"
      freshrss-url "https://rss.${domain}/api/greader.php"
      freshrss-login "${username}"
      freshrss-passwordeval "rbw get 'freshrss api'"
      '';
  };
}

