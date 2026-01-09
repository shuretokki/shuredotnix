# https://git-scm.com/
# https://home-manager-options.extranix.com/?query=programs.git

{ lib, prefs, ... }: {
  programs.git = {
    enable = true;
    settings = {
      user.name = prefs.gitname;
      user.email = prefs.email;

      push.autoSetupRemote = true;
      pull.rebase = true;
      credential.helper = "!gh auth git-credential";

      alias = {
        last = "log -1 HEAD";
      };
    };
  };
}
