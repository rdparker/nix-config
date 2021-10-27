{ inputs, config, pkgs, ... }:
let
  checkBrew = "command -v brew > /dev/null";
  installBrew = ''
    ${pkgs.bash}/bin/bash -c "$(${pkgs.curl}/bin/curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"'';
in
{
  environment = {
    # install homebrew
    extraInit = ''
      ${checkBrew} || ${installBrew}
    '';
  };

  homebrew = {
    enable = true;
    autoUpdate = true;
    global = {
      brewfile = true;
      noLock = true;
    };

    taps = [
      "beeftornado/rmtree"
      "homebrew/bundle"
      "homebrew/cask"
      "homebrew/cask-fonts"
      "homebrew/cask-versions"
      "homebrew/core"
      "homebrew/services"
      "teamookla/speedtest"
      "mczachurski/wallpapper"
    ];

    brews = [
      "beeftornado/rmtree/brew-rmtree"
      "mas"
      "pngpaste"                        # Used for Org drag and drop
      "teamookla/speedtest/speedtest"
      "wallpapper"
    ];

    casks = [
      "goland"
      "iglance"
      "rider"
      "xquartz"                 # Needed by mcgimp
      "gimp"                    # Stable, up-to-date Gimp
      "mcgimp"                  # Gimp with plugins
    ];

    masApps = {
      "Xcode" = 497799835;      # Needed by wallpapper in apps.nix
    };
  };
}
