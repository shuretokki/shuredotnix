{ lib, vars, ... }: {
  imports = [
    ../bundlers/cli
    ../bundlers/desktop
  ];

  xdg.enable = lib.mkDefault true;

  programs.git.settings.user = {
    name = vars.gitname;
    email = vars.email;
  };

  news.display = "silent";
}
