{ vars, ... }:

{
  services.espanso = {
    enable = true;
    configs = {
      default = {
        show_notifications = false;
        keyboard_layout = {
          layout = "gb";
          };
      };
    };
    matches = {
      base = {
        matches = [
          # sort:start
          { trigger = "(!!)"; replace = "¡"; }
          { trigger = "(!?)"; replace = "‽"; }
          { trigger = "(?!)"; replace = "‽"; }
          { trigger = "(??)"; replace = "¿"; }
          { trigger = "(Ae)"; replace = "Æ"; }
          { trigger = "(ae)"; replace = "æ"; }
          { trigger = "(Ai)"; replace = "Ä"; }
          { trigger = "(ai)"; replace = "ä"; }
          { trigger = "(Ao)"; replace = "Å"; }
          { trigger = "(ao)"; replace = "å"; }
          { trigger = "(deg)"; replace = "°"; }
          { trigger = "(O/)"; replace = "Ø"; }
          { trigger = "(o/)"; replace = "ø"; }
          { trigger = "(Oi)"; replace = "Ö"; }
          { trigger = "(oi)"; replace = "ö"; }
          { trigger = "_addr"; replace = "${vars.user.address}"; }
          { trigger = "_date"; replace = "{{date}}"; }
          { trigger = "_dttime"; replace = "{{datetime}}"; }
          { trigger = "_hem"; replace = "${vars.user.email}"; }
          { trigger = "_kreg"; replace = "\n\nKind regards,\n${vars.user.fullname}"; }
          { trigger = "_reg"; replace = "\n\nRegards,\n${vars.user.fullname}"; }
          { trigger = "_time"; replace = "{{time}}"; }
          # sort:end
        ];
         global_vars = [
           # sort:start
           { name = "date"; type = "date"; params = { format = "%Y-%m-%d"; }; }
           { name = "datetime"; type = "date"; params = { format = "%Y-%m-%dT%H:%M"; }; }
           { name = "time"; type = "date"; params = { format = "%H:%M"; }; }
           # sort:end
        ];
        };
    };
  };
}
