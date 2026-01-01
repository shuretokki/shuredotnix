    includes = [
      { path = config.sops.templates."git-identity".path; }
    ];
  };

  sops.secrets.git_name = { owner = vars.username; };
  sops.secrets.git_email = { owner = vars.username; };

  sops.templates."git-identity" = {
    owner = vars.username;
    content = ''
      [user]
        name = ${config.sops.placeholder.git_name}
        email = ${config.sops.placeholder.git_email}
    '';
  };
in {
  programs.git = {
    enable = lib.mkDefault true;
    lfs.enable = lib.mkDefault true;

    settings = {
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
