{ fullname, email, ... }:

{
  programs.git = {
    enable = true;
    settings = {
      user.name = "${fullname}";
      user.email = "${email}";
    };
  };
}
