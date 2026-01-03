{
  lib,
  pkgs,
  ...
}:
{
  programs.zoxide = {
    enable = lib.mkDefault true;
    enableBashIntegration = true;
    options = [ ];
  };
}
