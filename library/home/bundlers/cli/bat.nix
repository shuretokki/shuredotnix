{ lib, ... }: {
  programs.bat = {
    enable = lib.mkDefault true;
    config = {
      theme = lib.mkDefault "gruvbox-dark";
      style = lib.mkDefault "numbers,changes";
    };
  };
}
