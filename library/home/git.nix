{ vars, ... }: {
  programs.git = {
    enable = true;
    settings.user.name = vars.gitname;
    settings.user.email = vars.email;
    extraConfig = {
      init.defaultBranch = "master";
    };
  };
}
