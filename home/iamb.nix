{ matrixuser, matrixserver, ... }:

{
  programs.iamb = {
    enable = true;
		settings = {
		  "default_profile" = "user";
		  profiles.user = {
			  "user_id" = "${matrixuser}";
				"url" = "${matrixserver}";
				};
		};
  };
}
