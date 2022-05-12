{ inputs, config, lib, pkgs, ... }: {
  imports = [ ./primary.nix ./nixpkgs.nix ./overlays.nix ];

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableBashCompletion = true;
    # enableAutosuggestions = true;
    enableSyntaxHighlighting = true;
    # enableVteIntegration = true;
    # defaultKeymap = "emacs";
    # initExtra = "test -e \"\${HOME}/.iterm2_shell_integration.zsh\" && source \"\${HOME}/.iterm2_shell_integration.zsh\"\n[ -f \"\${HOME}/.ghcup/env\" ] && source \"\${HOME}/.ghcup/env\" # ghcup-env";
  };

  user = {
    description = "Ron Parker";
    home = "${
        if pkgs.stdenvNoCC.isDarwin then "/Users" else "/home"
      }/${config.user.name}";
    shell = pkgs.zsh;
  };

  # bootstrap home manager using system config
  hm = import ./home-manager;

  # let nix manage home-manager profiles and use global nixpkgs
  home-manager = {
    extraSpecialArgs = { inherit inputs lib; };
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
  };

  # environment setup
  environment = {
    systemPackages = with pkgs;
      [
        # editors
        emacs

        # standard toolset
        coreutils
        curl
        wget
        git
        git-annex
        jq
        multitail
        pstree
        watch

        # helpful shell stuff
        bat
        fzf
        ispell
        ripgrep
        shellcheck
        tmux
        zsh

        # Language Support
        rust-analyzer-unwrapped
      ];
    etc = {
      home-manager.source = "${inputs.home-manager}";
      nixpkgs.source = "${inputs.nixpkgs}";
    };
    # list of acceptable shells in /etc/shells
    shells = with pkgs; [ bash zsh fish ];
    # For programs.zsh.enableCompletion to pick up system commands
    pathsToLink = [ "/share/zsh" ];
  };

  fonts.fonts = with pkgs; [
    emacs-all-the-icons-fonts
    fira
    fira-code
    font-awesome
    jetbrains-mono
  ];
}
