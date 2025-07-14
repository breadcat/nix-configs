{ pkgs, username, ... }:

{
  boot.kernelModules = [ "uinput" ];
  users.users.${username}.extraGroups = [ "uinput" ];
  # Define the uinput group
  users.groups.uinput = {};

  # Install ydotool system-wide
  environment.systemPackages = with pkgs; [
    ydotool
  ];

  # Udev rule to allow group access to /dev/uinput
  services.udev.extraRules = ''
    KERNEL=="uinput", GROUP="uinput", MODE="0660"
  '';

  # Set capabilities on ydotool via a wrapper so it persists rebuilds
  security.wrappers.ydotool = {
    source = "${pkgs.ydotool}/bin/ydotool";
    capabilities = "cap_sys_admin,cap_dac_override,cap_sys_nice+ep";
    owner = "root";
    group = "uinput";
    permissions = "u+rx,g+rx";
  };
}
