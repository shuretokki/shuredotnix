{ lib, ... }: {
  programs.btop = {
    enable = lib.mkDefault true;
    settings = {
      theme_background = lib.mkDefault false;
      vim_keys = lib.mkDefault true;
    };
  };
}
