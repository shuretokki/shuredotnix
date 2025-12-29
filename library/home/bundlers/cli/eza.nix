{ lib, ... }: {
  programs.eza = {
    enable = lib.mkDefault true;
    enableBashIntegration = lib.mkDefault true;
    icons = lib.mkDefault "auto";
    git = lib.mkDefault true;
    extraOptions = [ "--group-directories-first" ];
  };
}
