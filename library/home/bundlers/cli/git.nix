{ lib, vars, ... }: {
  programs.git = {
    enable = lib.mkDefault true;
    lfs.enable = lib.mkDefault true;

    settings = {
      user = {
        name = lib.mkDefault vars.gitname;
        email = lib.mkDefault vars.email;
      };
      init.defaultBranch = lib.mkDefault "main";
      push.autoSetupRemote = lib.mkDefault true;
      pull.rebase = lib.mkDefault true;
      credential.helper = "!gh auth git-credential";

      alias = {
        co = "checkout";
        st = "status";
        lg = "log --oneline --graph --decorate";
        last = "log -1 HEAD";
      };
    };
  };
}
