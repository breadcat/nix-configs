{
  programs.htop = {
    enable = true;
    settings = {
      shadow_other_users = 1;
      tree_view = 1;
      hide_userland_threads = 1;
      columnMeters0 = ["AllCPUs" "Memory"];
      columnMeterModes0 = [1 1];
      columnMeters1 = ["DateTime" "Tasks" "LoadAverage" "Uptime" "System"];
      columnMeterModes1 = [2 2 2 2 2];
    };
  };
}
