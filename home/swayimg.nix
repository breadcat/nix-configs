{
  programs.swayimg.enable = true;
    xdg.configFile."swayimg/init.lua".text = ''
    swayimg.viewer.on_key("Control-Delete", function()
      local img = swayimg.viewer.get_image()
      if img then
        os.remove(img.path)
        swayimg.imagelist.remove(img.path)
      end
    end)
  '';
}
