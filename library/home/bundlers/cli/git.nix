# https://github.com/nix-community/home-manager/blob/master/modules/programs/git.nix

{ lib, vars, ... }: {
  programs.git = {
    enable = true;
    settings = {
      user.name = vars.gitname;
      user.email = vars.email;

      push.autoSetupRemote = true;
      pull.rebase = true;

      alias = {
        last = "log -1 HEAD";
      };
    };
  };
}
