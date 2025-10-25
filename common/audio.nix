{ pkgs, ... }: {

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    wireplumber.enable = true;
    alsa.enable = true;
    pulse.enable = true;
    };

  environment.systemPackages = with pkgs; [ pavucontrol ];

}
