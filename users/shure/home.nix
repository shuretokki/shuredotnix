# https://home-manager-options.extranix.com/?query=home

# user-specific home-manager configuration.
# this file is imported when building for the "shure" user.
# _prefs are passed down to bundlers to customize app behavior.

{ config, pkgs, inputs, vars, ... }: {
  imports = [
    ../../library/home/global # base home config shared by all users
  ];

  # user preferences consumed by bundlers.
  # changing these affects: git config, default apps, keybinds.
  # see library/home/prefs.nix for the option definitions.
  _prefs = {
    gitname = "Tri R. Utomo";
    email = "tri.r.utomo@gmail.com";
    browser = "zen";
    terminal = "warp-terminal";
    editor = "code";
    fileManager = "nautilus";
    musicPlayer = "spotify";
  };

  home.username = vars.username;
  home.homeDirectory = "/home/${vars.username}";

  # do not change after initial install.
  # see: https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "25.11";
}
