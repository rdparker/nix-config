{ inputs, config, pkgs, ... }:
let
  homeDir = config.home.homeDirectory;
  extraNodePackages = import ./node/default.nix { inherit pkgs; };
  pyEnv = (pkgs.stable.python3.withPackages
    (ps: with ps; [ black pylint typer colorama shellingham ]));
  sysDoNixos =
    "[[ -d /etc/nixos ]] && cd /etc/nixos && ${pyEnv}/bin/python bin/do.py $@";
  sysDoDarwin =
    "[[ -d ${homeDir}/.nixpkgs ]] && cd ${homeDir}/.nixpkgs && ${pyEnv}/bin/python bin/do.py $@";
  sysdo = (pkgs.writeShellScriptBin "sysdo" ''
    (${sysDoNixos}) || (${sysDoDarwin})
  '');

in
{
  imports = [ ./cli ./kitty ./dotfiles ./git.nix ];

  programs.home-manager = {
    enable = true;
    path = "${config.home.homeDirectory}/.nixpkgs/modules/home-manager";
  };

  home =
    let
      java = pkgs.adoptopenjdk-bin;
    in
    {
      # This value determines the Home Manager release that your
      # configuration is compatible with. This helps avoid breakage
      # when a new Home Manager release introduces backwards
      # incompatible changes.
      #
      # You can update Home Manager without changing this value. See
      # the Home Manager release notes for a list of state version
      # changes in each release.
      stateVersion = "20.09";
      sessionVariables = {
        GPG_TTY = "/dev/ttys000";
        EDITOR = "emacs";
        VISUAL = "emacs";
        CLICOLOR = 1;
        LSCOLORS = "ExFxBxDxCxegedabagacad";
        KAGGLE_CONFIG_DIR = "${config.xdg.configHome}/kaggle";
        JAVA_HOME = "${java}";
      };

      # define package definitions for current user environment
      packages = with pkgs; with extraNodePackages; [
        # python with default packages
        (python39.withPackages (ps: with ps; [ black numpy scipy networkx ]))
        bash-language-server
        cachix
        comma
        coreutils-full
        curl
        curlie
        fd
        gawk
        git
        gnugrep
        gnupg
        gnused
        home-manager
        htop
        httpie
        hyperfine
        java
        jq
        kotlin
        neofetch
        niv
        nix-index
        nixUnstable
        nixfmt
        nixpkgs-fmt
        stable.nodejs_latest
        openssh
        pandoc
        pre-commit
        python3Packages.poetry
        ranger
        ripgrep
        ripgrep-all
        rsync
        sysdo
        tealdeer
        tectonic
        yarn
        # texlive.combined.scheme-full
        youtube-dl
      ];
    };
}
