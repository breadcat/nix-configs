{ lib, ... }:
{
  programs.qutebrowser = {
    enable = true;
    settings = {
      colors.webpage.darkmode.enabled = true;
      url.start_pages = "https://breadcat.github.io/startpage/";
      url.default_page = "https://breadcat.github.io/startpage/";
    };
    extraConfig = ''
      config.bind('<Alt-Left>', 'back')
      config.bind('<Alt-Right>', 'forward')
      config.bind('<Ctrl-Tab>', 'tab-next')
      config.bind('<Ctrl-Shift-Tab>', 'tab-prev')
      config.set('tabs.last_close', 'close')
    '';
  };
}
