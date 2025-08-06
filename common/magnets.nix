{ pkgs, username, ... }:

let
  magnets = pkgs.writeShellScriptBin "magnets" ''
  # variables
  working_directory="$HOME/vault/watch"
  # trackers
  trackers_list=(
    "http://0123456789nonexistent.com:80/announce"
    "http://bt.okmp3.ru:2710/announce"
    "http://ipv4.rer.lol:2710/announce"
    "http://open.trackerlist.xyz:80/announce"
    "http://shubt.net:2710/announce"
    "http://taciturn-shadow.spb.ru:6969/announce"
    "http://torrent.hificode.in:6969/announce"
    "http://tracker.bt4g.com:2095/announce"
    "http://tracker.mywaifu.best:6969/announce"
    "http://tracker.netmap.top:6969/announce"
    "http://tracker.privateseedbox.xyz:2710/announce"
    "http://tracker.renfei.net:8080/announce"
    "https://pybittrack.retiolus.net:443/announce"
    "https://t.213891.xyz:443/announce"
    "https://tr.nyacat.pw:443/announce"
    "https://tracker.aburaya.live:443/announce"
    "https://tracker.expli.top:443/announce"
    "https://tracker.ghostchu-services.top:443/announce"
    "https://tracker.jdx3.org:443/announce"
    "https://tracker.leechshield.link:443/announce"
    "https://tracker.moeblog.cn:443/announce"
    "https://tracker.yemekyedim.com:443/announce"
    "https://tracker.zhuqiy.top:443/announce"
    "udp://1c.premierzal.ru:6969/announce"
    "udp://bandito.byterunner.io:6969/announce"
    "udp://d40969.acod.regrucolo.ru:6969/announce"
    "udp://evan.im:6969/announce"
    "udp://extracker.dahrkael.net:6969/announce"
    "udp://martin-gebhardt.eu:25/announce"
    "udp://open.demonii.com:1337/announce"
    "udp://open.dstud.io:6969/announce"
    "udp://open.stealth.si:80/announce"
    "udp://p4p.arenabg.com:1337/announce"
    "udp://retracker.lanta.me:2710/announce"
    "udp://retracker01-msk-virt.corbina.net:80/announce"
    "udp://tracker.bitcoinindia.space:6969/announce"
    "udp://tracker.dler.com:6969/announce"
    "udp://tracker.fnix.net:6969/announce"
    "udp://tracker.gigantino.net:6969/announce"
    "udp://tracker.gmi.gd:6969/announce"
    "udp://tracker.hifimarket.in:2710/announce"
    "udp://tracker.hifitechindia.com:6969/announce"
    "udp://tracker.kmzs123.cn:17272/announce"
    "udp://tracker.opentrackr.org:1337/announce"
    "udp://tracker.plx.im:6969/announce"
    "udp://tracker.qu.ax:6969/announce"
    "udp://tracker.rescuecrew7.com:1337/announce"
    "udp://tracker.skillindia.site:6969/announce"
    "udp://tracker.srv00.com:6969/announce"
    "udp://tracker.therarbg.to:6969/announce"
    "udp://tracker.torrent.eu.org:451/announce"
    "udp://tracker.torrust-demo.com:6969/announce"
    "udp://tracker.tryhackx.org:6969/announce"
    "udp://tracker.tvunderground.org.ru:3218/announce"
    "udp://tracker.valete.tf:9999/announce"
    "udp://tracker.yume-hatsuyuki.moe:6969/announce"
    "udp://tracker-udp.gbitt.info:80/announce"
    "udp://ttk2.nbaonlineservice.com:6969/announce"
    "udp://udp.tracker.projectk.org:23333/announce"
    "udp://www.torrent.eu.org:451/announce"
  )
  for i in "''${trackers_list[@]}"; do trackers="$i,$trackers"; done
  # process
  cd "$working_directory" || exit 1
  # magnet loop
  for j in *.magnet; do
    timeout 3m ${pkgs.aria2}/bin/aria2c --bt-tracker="$trackers" --bt-metadata-only=true --bt-save-metadata=true "$(cat "$j")" && rm "$j"
    # wait for files to be picked up
    sleep 30s
  done
  # removed added files
  rm -- *.added
  '';
in {
  environment.systemPackages = [ magnets ];

  systemd.timers.magnet-watcher = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "*:0/10";
      Persistent = true;
    };
  };

  systemd.services.magnet-watcher = {
    script = "magnets";
    path = [ "/run/current-system/sw" ];
    serviceConfig = {
      Type = "oneshot";
      User = "${username}";
    };
  };
}
