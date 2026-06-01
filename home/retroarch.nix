{ lib, pkgs, ... }:

    # Frontends: pegasus-frontend
    # Game engines: corsix-th, eduke32, openra, openrct2, openttd
    # Tools: mame-tools, moonlight-qt
    # Waiting: cemu, gopher64, rpcs3, xemu

let
  cores = [
    "dolphin"
    "flycast"
    "genesis-plus-gx"
    "melonds"
    "mesen"
    "mgba"
    "parallel-n64"
    "pcsx2"
    "ppsspp"
    "sameboy"
    "snes9x"
    "swanstation"
    ];
in

{
  programs.retroarch = {
    enable = true;
    cores = lib.genAttrs cores (_: { enable = true; });
    settings = {
      video_fullscreen = "true";
      input_driver = "wayland";
      video_driver = "vulkan";
      system_directory = "/tank/media/games/.firmware";
      rgui_browser_directory = "/tank/media/games";
      audio_driver = "pipewire";
      audio_enable_menu = "true";
      audio_enable_menu_bgm = "true";
      audio_enable_menu_cancel = "true";
      audio_enable_menu_notice = "true";
      audio_enable_menu_ok = "true";
      audio_enable_menu_scroll = "true";
      audio_mixer_mute_enabled = "false";
      content_show_favorites = "false";
      content_show_images = "false";
      content_show_netplay = "false";
      content_show_playlists = "false";
      content_show_video = "false";
      menu_driver = "xmb";
      xmb_menu_color_theme = "21";
      xmb_theme = "1";
    };
  };
}
