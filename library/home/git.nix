{ vars, ... }: {
  programs.git = {
    enable = true;
    settings = {
      user.name = vars.gitname;
      user.email = vars.email;
    };
    extraConfig = {
      credential.helper = "!gh auth git-credential";
    };
  };
}
