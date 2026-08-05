{ pkgs, ... }:

{

  environment.systemPackages = [
    (pkgs.writeShellScriptBin "vidyaplace-tears" ''

    # variables
      player="''${1:-Calico}"

    # process
      printf "Player: %s\n" "$player"
      ${pkgs.curl}/bin/curl -s "https://vidyaplace.org/api/highscores/player/$player" |
      ${pkgs.jq}/bin/jq -r '
      def format_number:
        tostring
        | if length <= 3 then .
          else (.[0:length-3] | format_number) + "," + .[length-3:]
          end;
        def format_skill:
          sub("_xp$"; "")
          | split("_")
          | map((.[0:1] | ascii_upcase) + .[1:])
          | join(" ");
        to_entries
        | map(select(.key | test("_(xp)$")))
        | sort_by(.value)
        | .[0] as $lowest
        | .[1] as $second
        |
        "Lowest skill: \($lowest.key | format_skill) (\($lowest.value | format_number) XP)",
        "Second lowest skill: \($second.key | format_skill) (\($second.value | format_number) XP)",
        "",
        "Difference: \(($second.value - $lowest.value) | format_number) XP"
      '
    '')
  ];

}
