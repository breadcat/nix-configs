{ vars, ... }:

{
  time.timeZone = vars.user.timezone;
  i18n.defaultLocale = vars.user.locale;
  i18n.extraLocaleSettings = {
    LC_ADDRESS = vars.user.locale;
    LC_IDENTIFICATION = vars.user.locale;
    LC_MEASUREMENT = vars.user.locale;
    LC_MONETARY = vars.user.locale;
    LC_NAME = vars.user.locale;
    LC_NUMERIC = vars.user.locale;
    LC_PAPER = vars.user.locale;
    LC_TELEPHONE = vars.user.locale;
    LC_TIME = vars.user.locale;
  };
  services.xserver.xkb.layout = "gb";
  console.keyMap = "uk";
}
