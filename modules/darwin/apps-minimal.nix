{ config, lib, pkgs, ... }: {
  homebrew = {
    casks = [
      "1password"
      "firefox-beta"
      "iterm2"
      "karabiner-elements"
      "keepingyouawake"
      "kitty"
      "microsoft-edge"
      "raycast"
      "visual-studio-code"
    ];
  };
}
