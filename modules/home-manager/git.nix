{ config, lib, pkgs, ... }: {
  home.packages = [ pkgs.github-cli ];
  programs.git = {
    userName = "Ron Parker";
    extraConfig = {
      credential.helper =
        if pkgs.stdenvNoCC.isDarwin then
          "osxkeychain"
        else
          "cache --timeout=1000000000";
      http.sslVerify = true;
      pull.rebase = false;
      commit.verbose = true;

      diff = {
        tool = "kitty";
        guitool = "kitty.gui";
      };
      difftool = {
        prompt = false;
        trustExitCode = true;
      };
      "difftool \"kitty\"".cmd = "kitty +kitten diff $LOCAL $REMOTE";
      "difftool \"kitty.gui\"".cmd = "kitty kitty +kitten diff $LOCAL $REMOTE";
    };
    aliases = {
      fix = "commit --amend --no-edit";
      oops = "reset HEAD~1";
    };
    delta.enable = true;
  };
}
