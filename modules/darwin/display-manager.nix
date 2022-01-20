{ config, pkgs, ... }: {

  # Yabai is now install from HEAD via homebrew in brew.nix.  This
  # because 3.x was crashing on Monteray.

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
