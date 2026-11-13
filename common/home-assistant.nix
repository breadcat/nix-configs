{ vars, ... }:
{

  services.home-assistant = {
    enable = true;
    config = {
      homeassistant = {
        name = "Home";
        time_zone = "Europe/London";
        unit_system = "metric";
      };

      http = {
        use_x_forwarded_for = true;
        trusted_proxies = [ "127.0.0.1" ];
      };

      default_config = {};
    };

    extraComponents = [ "tplink" ];
  };

}
