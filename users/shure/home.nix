{ config, pkgs, inputs, vars, ... }: {
  imports = [
    ../../library/home/global
  ];

  home.username = vars.username;
  home.homeDirectory = "/home/${vars.username}";
  home.stateVersion = "25.11";
}
