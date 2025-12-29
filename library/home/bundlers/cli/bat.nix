{ lib, ... }: {
  programs.bat = {
    enable = lib.mkDefault true;
    config = {
      style = lib.mkDefault "numbers,changes";
    };
  };
}
