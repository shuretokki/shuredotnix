{ vars, ... }: {
  programs.git = {
    enable = true;
    userName = vars.gitname;
    userEmail = vars.email;
  };
}
