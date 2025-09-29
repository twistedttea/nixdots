{
  config,
  pkgs,
  lib,
  ...
}:
{
  services.yabai = {
    enable = true;
    enableScriptingAddition = true;
    config = {
      layout = "bsp";
      auto_balance = "on";

      mouse_modifier = "alt";
      # set modifier + right-click drag to resize window (default: resize)
      mouse_action2 = "resize";
      # set modifier + left-click drag to resize window (default: move)
      mouse_action1 = "move";

      mouse_follows_focus = "off";
      focus_follows_mouse = "autofocus";

      # gaps
      top_padding = 15;
      bottom_padding = 15;
      left_padding = 15;
      right_padding = 15;
      window_gap = 15;
    };

    extraConfig = ''

      # pretty
      yabai -m config window_opacity on
      yabai -m config active_window_opacity 1.0
      yabai -m config normal_window_opacity 0.9
      # rules

      yabai -m rule --add app=".*" sub-layer=normal
      yabai -m rule --add app="^System Settings$"    manage=off
      yabai -m rule --add app="^System Information$" manage=off
      yabai -m rule --add app="^System Preferences$" manage=off
      yabai -m rule --add title="Preferences$"       manage=off
      yabai -m rule --add title="Settings$"          manage=off
      yabai -m rule --add app="Finder$"          manage=off
      yabai -m rule --add app="Spotify" space=utils

      # workspace management
      yabai -m space 1 --label browser
      yabai -m space 2 --label productive
      yabai -m space 3 --label emacs
      yabai -m space 4 --label social
      yabai -m space 5 --label utils
    '';
  };
}
