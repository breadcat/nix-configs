{ vars, ... }:

{
  programs.iamb = {
    enable = true;
		settings = {
		  "default_profile" = "user";
		  profiles.user = {
			  "user_id" = "${vars.matrix.user}";
				"url" = "${vars.matrix.homeserver}";
				};
		};
  };
}
