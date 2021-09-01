{ config, lib, pkgs, ... }: {
  programs.git = {
    userEmail = "rdparker@protonmail.com";
    userName = "Ron Parker";
    # signing = {
    #   key = "kennan@case.edu";
    #   signByDefault = true;
    # };
  };
}
