{ vars, ... }:

# Setup tokens here: https://github.com/settings/tokens

{
  programs.git = {
    enable = true;
    settings = {
      user.name = "${vars.user.fullname}";
      user.email = "${vars.user.email}";
    };
  };
}
