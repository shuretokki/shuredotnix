{ lib, ... }: {
  programs.fzf = {
    enable = lib.mkDefault true;
    enableBashIntegration = lib.mkDefault true;
    defaultOptions = [ "--height 40%" "--layout=reverse" "--border" ];
  };
}
