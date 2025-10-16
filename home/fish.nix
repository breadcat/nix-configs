{
  pkgs,
  domain,
  ...
}:

{
  programs.fish = {
    enable = true;
    functions = {
      __fish_command_not_found_handler = { body = "echo fish: Unknown command $argv[1]"; onEvent = "fish_command_not_found"; };
      backup = "tar -zcvf (basename \$argv)_backup-(date +%F-%H%M%S).tar.gz \$argv";
      book = "grep -i \"$argv\" \"$SYNCDIR/src/blog.${domain}/content/reading-list.md\"";
      dos2unix = "sed -i 's/\r//' \"$argv\"";
      mcd = "mkdir -p $argv[1] && cd $argv[1]";
      mergeinto = "rsync --progress --remove-source-files -av \"$argv[1]\" \"$argv[2]\" && find \"$argv[1]\" -empty -delete";
      vat = "math $argv + \"($argv * 0.2)\"";
    };
    loginShellInit = ''
      set fish_greeting # Disable greeting
      set --erase fish_greeting # Disable greeting
      set -gx DOMAIN ${domain}
      set -gx EDITOR nvim
      set -gx EMAIL (whoami)@${domain}
      set -gx SYNCDIR $HOME/vault
      set -gx VISUAL $EDITOR
    '';
    shellAliases = {
      crypto-sum = "${pkgs.rbw}/bin/rbw get 'crypto purchases' | awk '/^20/ {print $2}' | paste -sd+ | math";
      empties = "find . -maxdepth 3 -mount -not -path \"*/\.*\" -empty -print";
      extract = "${pkgs.atool}/bin/aunpack";
      jdupes = "jdupes -A"; # exclude hidden files
      ncdu = "${pkgs.rclone}/bin/rclone ncdu";
      vaultedit = "find \"$SYNCDIR\" -maxdepth 5 -type f -not -path \"\*/\.git\" | ${pkgs.fzf}/bin/fzf --preview \"cat {}\" --layout reverse | xargs -r -I{} \"$EDITOR\" {}";
      week = "date +%V";
    };
    #    binds = {
    #      "ctrl-h".command = "backward-kill-path-component";
    #      "ctrl-backspace".command = "kill-word";
    #    };
  };
}
