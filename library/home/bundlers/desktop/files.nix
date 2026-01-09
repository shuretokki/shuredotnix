# https://home-manager-options.extranix.com/?query=xdg.mimeApps
# https://github.com/Stunkymonkey/nautilus-open-any-terminal#configuration

{ lib, pkgs, identity, prefs, ... }: {
  home.packages = with pkgs; [
    nautilus
  ];

  xdg.mimeApps.defaultApplications = {
    "inode/directory" = lib.mkDefault "org.gnome.Nautilus.desktop";
  };

  dconf.settings."com/github/stunkymonkey/nautilus-open-any-terminal" = {
    terminal = prefs.terminal;
    keybindings = "<Ctrl><Alt>t";
    new-tab = false;
  };
}
