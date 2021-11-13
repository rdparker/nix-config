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
      "powershell"              # Needed by Visual Studio Code to keep
                                # PowerShell up to date.
      "visual-studio-code"
    ];
  };
}
