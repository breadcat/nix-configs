{ fullname, email, ... }:

{
  programs.git = {
    enable = true;
    userName = "${fullname}";
    userEmail = "${email}";
  };
}
