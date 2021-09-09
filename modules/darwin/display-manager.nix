{ config, pkgs, ... }: {
  services.yabai = {
    enable = true;
    package = pkgs.yabai;
    config = {
      mouse_follows_focus = "off";
      focus_follows_mouse = "off";
      window_placement = "second_child";
      window_topmost = "off";
      window_opacity = "off";
      window_opacity_duration = 0.0;
      window_shadow = "on";
      window_border = "off";
      window_border_placement = "inset";
      window_border_width = 4;
      window_border_radius = -1.0;
      active_window_border_topmost = "off";
      active_window_border_color = "0xff775759";
      normal_window_border_color = "0xff505050";
      insert_window_border_color = "0xffd75f5f";
      active_window_opacity = 1.0;
      normal_window_opacity = 0.9;
      split_ratio = 0.5;
      auto_balance = "on";
      mouse_modifier = "fn";
      mouse_action1 = "move";
      mouse_action2 = "resize";
      layout = "bsp";
      top_padding = 5;
      bottom_padding = 5;
      left_padding = 5;
      right_padding = 5;
      window_gap = 5;
      external_bar = "main:26:0";
    };
  };

  launchd.user.agents.yabai.serviceConfig.StandardErrorPath = "/tmp/yabai.log";
  launchd.user.agents.yabai.serviceConfig.StandardOutPath = "/tmp/yabai.log";

  services.skhd = {
    enable = true;
    package = pkgs.skhd;
    skhdConfig = builtins.readFile ../home-manager/dotfiles/skhd/skhdrc;
  };

  services.spacebar = {
    enable = true;
    package = pkgs.spacebar;
    config = {
      debug_output = "on";
      display = "main";
      position = "top";
      clock_format = ''"%l:%M %d"'';
      text_font = ''"PragmataPro Liga:Regular:15.0"'';
      icon_font = ''"Font Awesome 5 Free:Solid:14.0"'';
      background_color = "0xff222222";
      foreground_color = "0xffd8dee9";
      space_icon_color = "0xffffab91";
      dnd_icon_color = "0xffd8dee9";
      clock_icon_color = "0xffd8dee9";
      power_icon_color = "0xffd8dee9";
      battery_icon_color = "0xffd8dee9";
      power_icon_strip = " ";
      space_icon = "•";
      space_icon_strip = "I II III IV V VI VII VIII IX X";
      spaces_for_all_displays = "on";
      display_separator = "on";
      display_separator_icon = "";
      space_icon_color_secondary = "0xff78c4d4";
      space_icon_color_tertiary = "0xfffff9b0";
      clock_icon = "";
      dnd_icon = "";
      right_shell = "off";
      right_shell_icon = "";
      right_shell_icon_color = "0xffd8dee9";
    };
  };

  launchd.user.agents.spacebar.serviceConfig.EnvironmentVariables.PATH = pkgs.lib.mkForce
    (builtins.replaceStrings [ "$HOME" ] [ "/Users/${config.user.name}" ] config.environment.systemPath);
  launchd.user.agents.spacebar.serviceConfig.StandardErrorPath = "/tmp/spacebar.err.log";
  launchd.user.agents.spacebar.serviceConfig.StandardOutPath = "/tmp/spacebar.out.log";
}
