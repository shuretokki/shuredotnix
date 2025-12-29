{ lib, ... }: {
  programs.zoxide = {
    enable = lib.mkDefault true;
    enableBashIntegration = lib.mkDefault true;
  };
}
