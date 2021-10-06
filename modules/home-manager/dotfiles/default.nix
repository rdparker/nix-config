{ config, pkgs, inputs, ... }: {
  home.file = {
    doom = {
      source = ./doom-emacs;
      target = ".doom.d";
      recursive = true;
    };
    keras = {
      source = ./keras;
      target = ".keras";
      recursive = true;
    };
    org-mac-iCal = with inputs; {
      source = org-mac-iCal;
      target = ".doom.d/local/org-mac-iCal";
      recursive = true;
    };
    raycast = {
      source = ./raycast;
      target = ".local/bin/raycast";
      recursive = true;
    };
    zfunc = {
      source = ./zfunc;
      target = ".zfunc";
      recursive = true;
    };
  };

  xdg.enable = true;
  xdg.configFile = {
    "nixpkgs/config.nix".source = ../../config.nix;
    karabiner = {
      source = ./karabiner;
      recursive = true;
    };
    skhd = {
      source = ./skhd;
      recursive = true;
    };
    yabai = {
      source = ./yabai;
      recursive = true;
    };
  };
}
