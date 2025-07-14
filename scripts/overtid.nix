{ pkgs, ... }:

let
  overtid = pkgs.writeShellScriptBin "overtid" ''
    # variables
    time_start="08:30"
    time_end="18:00"
    # check for arguments
    if [ $# -eq 0 ]; then
      printf "Decimal overtime calculator\\nUsage: %s HH:MM (HH:MM)\\n" "''${0##*/}"
      exit 1
    fi
    # main logic
    # no second variable, calculate singularly
    if [ -z ''${2+x} ]; then
      start="$(date -d "Yesterday $1" "+%s")"
      if [ "''${time_start:0:2}" -gt "''${1:0:2}" ]; then
        end="$(date -d "Yesterday $time_start" "+%s")"
        printf "Early start: %s hours\\n" "$(date -d\@$((end - start)) -u +'scale=2; %H + %M/60' | ${pkgs.bc}/bin/bc)"
      else
        end="$(date -d "Yesterday $time_end" "+%s")"
        printf "Late finish: %s hours\\n" "$(date -d\@$((start - end)) -u +'scale=2; %H + %M/60' | ${pkgs.bc}/bin/bc)"
      fi
    # second variable, calculate both and combine
    else
      start_am="$(date -d "Yesterday $1" "+%s")"
      start_pm="$(date -d "Yesterday $2" "+%s")"
      end_am="$(date -d "Yesterday $time_start" "+%s")"
      end_pm="$(date -d "Yesterday $time_end" "+%s")"
      printf "Combined overtimes: %s hours\\n" "$(echo "$(date -d\@$((end_am - start_am)) -u +'scale=2; %H + %M/60' | ${pkgs.bc}/bin/bc)" + "$(date -d\@$((start_pm - end_pm)) -u +'scale=2; %H + %M/60' | ${pkgs.bc}/bin/bc)" | ${pkgs.bc}/bin/bc)"
    fi
  '';

in {
  environment.systemPackages = [ overtid ];
}
