{
  programs.lf = {
    enable = true;
		settings = {
		  icons = true;
			ignorecase = true;
		};
    keybindings = {
		  "." = "set hidden!";
			"<delete>" = "delete";
			"<enter>" = "shell";
			"d" = "delete";
			"i" = "$swayimg -r *";
			"gv" = "cd ~/vault";
    };
  };
}
