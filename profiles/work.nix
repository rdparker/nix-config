{ config, lib, pkgs, ... }: {
  user.name = "pron";
  hm = { imports = [ ./home-manager/work.nix ]; };

  security.pki.certificateFiles = [
    # "${config.user.home}/root-cert.cer"
    "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"
  ];
}
