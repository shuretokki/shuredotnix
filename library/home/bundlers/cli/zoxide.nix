# https://github.com/nix-community/home-manager/blob/master/modules/programs/zoxide.nix

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
