{ lib, machine, vars, ... }:

let
  numlockMachines = [ "atlas" "arcadia" ]; numlockEnabled = builtins.elem machine numlockMachines;
in
{
  wayland.windowManager.hyprland = {
    enable = true;
    configType = "lua";
    extraConfig = ''
      -- General
      hl.config({
        general={gaps_in=5,gaps_out=20,border_size=2,col={active_border={colors={"rgba(33ccffee)","rgba(00ff99ee)"},angle=45},inactive_border="rgba(595959aa)"},resize_on_border=false,allow_tearing=false,layout="dwindle"},
        decoration={rounding=10,rounding_power=2,active_opacity=1.0,inactive_opacity=1.0,shadow={enabled=true,range=4,render_power=3,color=0xee1a1a1a},blur={enabled=true,size=3,passes=1,vibrancy=0.1696}},
        animations={enabled=true}
      })
      -- Animations
      hl.curve("easeOutQuint",   { type = "bezier", points = { {0.23, 1},    {0.32, 1}    } })
      hl.curve("easeInOutCubic", { type = "bezier", points = { {0.65, 0.05}, {0.36, 1}    } })
      hl.curve("linear",         { type = "bezier", points = { {0, 0},       {1, 1}       } })
      hl.curve("almostLinear",   { type = "bezier", points = { {0.5, 0.5},   {0.75, 1}    } })
      hl.curve("quick",          { type = "bezier", points = { {0.15, 0},    {0.1, 1}     } })
      hl.curve("easy",           { type = "spring", mass = 1, stiffness = 71.2633, dampening = 15.8273644 })
      hl.animation({ leaf = "global",        enabled = true,  speed = 10,   bezier = "default" })
      hl.animation({ leaf = "border",        enabled = true,  speed = 5.39, bezier = "easeOutQuint" })
      hl.animation({ leaf = "windows",       enabled = true,  speed = 4.79, spring = "easy" })
      hl.animation({ leaf = "windowsIn",     enabled = true,  speed = 4.1,  spring = "easy",         style = "popin 87%" })
      hl.animation({ leaf = "windowsOut",    enabled = true,  speed = 1.49, bezier = "linear",       style = "popin 87%" })
      hl.animation({ leaf = "fadeIn",        enabled = true,  speed = 1.73, bezier = "almostLinear" })
      hl.animation({ leaf = "fadeOut",       enabled = true,  speed = 1.46, bezier = "almostLinear" })
      hl.animation({ leaf = "fade",          enabled = true,  speed = 3.03, bezier = "quick" })
      hl.animation({ leaf = "layers",        enabled = true,  speed = 3.81, bezier = "easeOutQuint" })
      hl.animation({ leaf = "layersIn",      enabled = true,  speed = 4,    bezier = "easeOutQuint", style = "fade" })
      hl.animation({ leaf = "layersOut",     enabled = true,  speed = 1.5,  bezier = "linear",       style = "fade" })
      hl.animation({ leaf = "fadeLayersIn",  enabled = true,  speed = 1.79, bezier = "almostLinear" })
      hl.animation({ leaf = "fadeLayersOut", enabled = true,  speed = 1.39, bezier = "almostLinear" })
      hl.animation({ leaf = "workspaces",    enabled = true,  speed = 1.94, bezier = "almostLinear", style = "fade" })
      hl.animation({ leaf = "workspacesIn",  enabled = true,  speed = 1.21, bezier = "almostLinear", style = "fade" })
      hl.animation({ leaf = "workspacesOut", enabled = true,  speed = 1.94, bezier = "almostLinear", style = "fade" })
      hl.animation({ leaf = "zoomFactor",    enabled = true,  speed = 7,    bezier = "quick" })
      -- Monitors
      hl.monitor({output="",mode="preferred",position="auto",scale="auto"})
      -- Environment
      hl.env("XCURSOR_SIZE", "24")
      hl.env("HYPRCURSOR_SIZE", "24")
      -- Layouts
      hl.config({dwindle={preserve_split=true}})
      hl.config({master={new_status="master"}})
      hl.config({scrolling={fullscreen_on_one_column=true}})
      -- Misc
      hl.config({misc={force_default_wallpaper=0,disable_hyprland_logo=true,disable_splash_rendering=true}})
      -- Input
      hl.config({input={numlock_by_default=${lib.boolToString numlockEnabled},kb_layout="gb",kb_options="caps:backspace",follow_mouse=1,sensitivity=0,touchpad={natural_scroll=false}}})
      -- Launch binds
      hl.bind("SUPER + RETURN", hl.dsp.exec_cmd("alacritty"))
      hl.bind("SUPER + W", hl.dsp.exec_cmd("chromium"))
      hl.bind("SUPER + SHIFT + W", hl.dsp.exec_cmd("chromium --incognito"))
      hl.bind("SUPER + R", hl.dsp.exec_cmd("tofi-run | xargs -I{} sh -c '{}'"))
      hl.bind("ALT + Tab", hl.dsp.window.cycle_next())
      hl.bind("ALT + SHIFT + Tab", hl.dsp.window.cycle_next({ next = false }))
      hl.bind("SUPER + SHIFT + Q", hl.dsp.window.close())
      hl.bind("SUPER + E", hl.dsp.exec_cmd("alacritty -e lf"))
      -- WM controls
      hl.bind("SUPER + Space", hl.dsp.window.float({ action = "toggle" }))
      hl.bind("SUPER + F", hl.dsp.window.fullscreen())
      hl.bind("SUPER + P", hl.dsp.window.pseudo())
      hl.bind("SUPER + J", hl.dsp.layout("togglesplit"))    -- dwindle only
      hl.bind("SUPER + left",  hl.dsp.focus({ direction = "left" }))
      hl.bind("SUPER + right", hl.dsp.focus({ direction = "right" }))
      hl.bind("SUPER + up",    hl.dsp.focus({ direction = "up" }))
      hl.bind("SUPER + down",  hl.dsp.focus({ direction = "down" }))
      for a=1,10 do local b=a%10;
        hl.bind("SUPER + "..b,hl.dsp.focus({workspace=a}))
        hl.bind("SUPER + SHIFT + "..b,hl.dsp.window.move({workspace=a}))
      end
      hl.bind("ALT + mouse:272", hl.dsp.window.drag(),   { mouse = true })
      hl.bind("ALT + mouse:273", hl.dsp.window.resize(), { mouse = true })
      -- Media binds
      hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
      hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      { locked = true, repeating = true })
      hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { locked = true, repeating = true })
      hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),   { locked = true, repeating = true })
      hl.bind("XF86MonBrightnessUp",  hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),                  { locked = true, repeating = true })
      hl.bind("XF86MonBrightnessDown",hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),                  { locked = true, repeating = true })
      hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
      hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
      hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
      hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })
      -- Smart gaps
      hl.workspace_rule({ workspace = "w[tv1]", gaps_out = 0, gaps_in = 0 })
      hl.workspace_rule({ workspace = "f[1]", gaps_out = 0, gaps_in = 0 })
      hl.window_rule({ match = { float = false, workspace = "w[tv1]" }, border_size = 0 })
      hl.window_rule({ match = { float = false, workspace = "w[tv1]" }, rounding = 0 })
      hl.window_rule({ match = { float = false, workspace = "f[1]" }, border_size = 0 })
      hl.window_rule({ match = { float = false, workspace = "f[1]" }, rounding = 0 })
      -- Ignore maximize requests from all apps
      hl.window_rule({name="suppress-maximize-events",match={class=".*"},suppress_event="maximize"})
      -- Fix XWayland dragging issues
      hl.window_rule({name="fix-xwayland-drags",match={class="^$",title="^$",xwayland=true,float=true,fullscreen=false,pin=false},no_focus=true})
    '';
    };

  dconf.enable = true;

  programs.fish.interactiveShellInit = ''
      if test (tty) = "/dev/tty1"; exec start-hyprland; end
    '';

}
