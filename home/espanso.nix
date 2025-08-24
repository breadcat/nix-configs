{ pkgs, ... }:

{
  services.espanso = {
    enable = true;
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
        ];
      };
    };
  };
}