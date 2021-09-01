{ config, lib, pkgs, ... }: {
  user.name = "rdp";
  hm = { imports = [ ./home-manager/personal.nix ]; };
}
