{ config, pkgs, ... }:
let theme = builtins.readFile ./theme.conf;
in
{
  programs.kitty = {
    enable = true;
    font = {
      name = "PragmataPro Mono Liga";
    };
    settings = {
      bold_font = "auto";
      italic_font = "auto";
      bold_italic_font = "auto";
      font_size = (if pkgs.stdenvNoCC.isDarwin then 18 else 12);
      strip_trailing_spaces = "smart";
      enable_audio_bell = "no";
      term = "xterm-256color";
      macos_titlebar_color = "background";
      macos_option_as_alt = "yes";
      scrollback_lines = 10000;
    };
    extraConfig = ''
      action_alias launch_tab launch --type=tab --cwd=current
      map f1 launch_tab
      map f2 launch_tab emacsclient -a "" .
      ${theme}
    '';
  };
}
