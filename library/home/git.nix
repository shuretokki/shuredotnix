{ vars, ... }: {
  programs.git = {
    enable = true;
    settings = {
      user.name = vars.gitname;
      user.email = vars.email;
      init.defaultBranch = "master";
    };
  };
}
