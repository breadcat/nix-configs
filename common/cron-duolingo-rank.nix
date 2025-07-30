{ username, ... }:
{
  systemd.timers.duolingoRank = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "Sun 23:59";
      Persistent = true;
    };
  };
  systemd.services.duolingoRank = {
    script = "blog-duolingo-rank";
    serviceConfig = {
      Type = "oneshot";
      User = "${username}";
    };
  };
}
