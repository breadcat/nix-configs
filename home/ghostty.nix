{
  programs.ghostty = {
    enable = true;
    settings = {
      theme = "base16-dark";
      font-size = 11;
    };
    themes =
    {
      base16-dark = {
        background = "1d1f21";
        cursor-color = "c5c8c6";
        foreground = "c5c8c6";
        palette = [
          "0=#282a2e"
            "1=#a54242"
            "2=#8c9440"
            "3=#de935f"
            "4=#5f819d"
            "5=#85678f"
            "6=#5e8d87"
            "7=#707880"
            "8=#373b41"
            "9=#cc6666"
            "10=#b5bd68"
            "11=#f0c674"
            "12=#8ae2be"
            "13=#b294bb"
            "14=#8abeb7"
            "15=#c5c8c6"
        ];
        selection-background = "353749";
        selection-foreground = "cdd6f4";
      };
    };
  };
}
