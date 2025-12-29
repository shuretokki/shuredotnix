{ lib, pkgs, vars, ... }: {
  programs.vscode = {
    enable = lib.mkDefault true;
    package = lib.mkDefault pkgs.vscode-fhs;
    mutableExtensionsDir = lib.mkDefault true;
  };

  home.sessionVariables = {
    EDITOR = lib.mkDefault vars.editor;
    VISUAL = lib.mkDefault vars.editor;
  };
}
