# https://home-manager-options.extranix.com/?query=programs.vscode
# TODO: consider adding zed (https://zed.dev/)
# TODO: make vscode declarative (extensions, settings)

{ lib, pkgs, prefs, ... }: {
  programs.vscode = {
    enable = lib.mkDefault true;
    package = lib.mkDefault pkgs.vscode-fhs;
    mutableExtensionsDir = lib.mkDefault true;
  };

  home.sessionVariables = {
    EDITOR = lib.mkDefault prefs.editor;
    VISUAL = lib.mkDefault prefs.editor;
  };
}
