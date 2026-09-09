{
  services.hypridle = {
    enable = true;
    settings = {
  general = {
    after_sleep_cmd = "hyprctl dispatch 'hl.dsp.dpms({ action = \"enable\" })'";
    ignore_dbus_inhibit = false;
    lock_cmd = "hyprlock";
  };
  listener = [
    {
      timeout = 300;
      on-timeout = "hyprctl dispatch 'hl.dsp.dpms({ action = \"disable\" })'";
      on-resume = "hyprctl dispatch 'hl.dsp.dpms({ action = \"enable\" })'";
    }
  ];
};
  };
}
