{
  programs.fish = {
    enable = true;
    functions = {
      __fish_command_not_found_handler = { body = "echo fish: Unknown command $argv[1]"; onEvent = "fish_command_not_found"; };
      vat = "math $argv + \"($argv * 0.2)\"";
      mcd = "mkdir -p $argv[1] && cd $argv[1]";
			mergeinto = "rsync --progress --remove-source-files -av \"$argv[1]\" \"$argv[2]\" && find \"$argv[1]\" -empty -delete";
    };
    loginShellInit = ''
      set fish_greeting # Disable greeting
      set --erase fish_greeting # Disable greeting
      set -gx DOMAIN minskio.co.uk
      set -gx SYNCDIR $HOME/vault
      set -gx EDITOR nvim
      set -gx VISUAL $EDITOR
    '';
    shellAliases = {
      extract = "aunpack";
      jdupes = "jdupes -A"; # exclude hidden files
      empties = "find . -maxdepth 3 -mount -not -path \"*/\.*\" -empty -print";
      vaultedit = "find \"$SYNCDIR\" -maxdepth 5 -type f | fzf --preview \"cat {}\" --layout reverse | xargs -r -I{} \"$EDITOR\" {}";
      week = "date +%V";
    };
#    binds = {
#      "ctrl-h".command = "backward-kill-path-component";
#      "ctrl-backspace".command = "kill-word";
#    };
  };
}
