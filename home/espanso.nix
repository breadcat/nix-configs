{ fullname, email, address, ... }:

{
  services.espanso = {
    enable = true;
    configs = {
      default = {
        keyboard_layout = {
          layout = "gb";
          };
      };
    };
    matches = {
      base = {
        matches = [
          { trigger = "(ae)"; replace = "æ"; }
          { trigger = "(Ae)"; replace = "Æ"; }
          { trigger = "(AE)"; replace = "Æ"; }
          { trigger = "(ai)"; replace = "ä"; }
          { trigger = "(Ai)"; replace = "Ä"; }
          { trigger = "(AI)"; replace = "Ä"; }
          { trigger = "(ao)"; replace = "å"; }
          { trigger = "(Ao)"; replace = "Å"; }
          { trigger = "(AO)"; replace = "Å"; }
          { trigger = "(o/)"; replace = "ø"; }
          { trigger = "(O/)"; replace = "Ø"; }
          { trigger = "(oi)"; replace = "ö"; }
          { trigger = "(Oi)"; replace = "Ö"; }
          { trigger = "(OI)"; replace = "Ö"; }
          { trigger = "(??)"; replace = "¿"; }
          { trigger = "(!!)"; replace = "¡"; }
          { trigger = "(?!)"; replace = "‽"; }
          { trigger = "(!?)"; replace = "‽"; }
          { trigger = "(deg)"; replace = "°"; }
          { trigger = "_date"; replace = "{{date}}"; }
          { trigger = "_time"; replace = "{{time}}"; }
          { trigger = "_dttime"; replace = "{{datetime}}"; }
          { trigger = "_reg"; replace = "\n\nRegards,\n${fullname}"; }
          { trigger = "_kreg"; replace = "\n\nKind regards,\n${fullname}"; }
          { trigger = "_hem"; replace = "${email}"; }
          { trigger = "_addr"; replace = "${address}"; }
        ];
         global_vars = [
          { name = "date"; type = "date"; params = { format = "%Y-%m-%d"; }; }
          { name = "time"; type = "date"; params = { format = "%H:%M"; }; }
          { name = "datetime"; type = "date"; params = { format = "%Y-%m-%dT%H:%M"; }; }
        ];
        };
    };
  };
}
