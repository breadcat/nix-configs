{ username, ... }:
{
  systemd.timers.duolingo-rank = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "Sun 23:59";
      Persistent = true;
    };
  };
  systemd.services.duolingo-rank = {
    script = "blog-duolingo-rank";
    path = [ "/run/current-system/sw" ];
    serviceConfig = {
      Type = "oneshot";
      User = "${username}";
    };
  };
}
