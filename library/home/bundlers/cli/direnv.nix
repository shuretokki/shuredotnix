{ lib, ... }: {
  programs.direnv = {
    enable = lib.mkDefault true;
    enableBashIntegration = lib.mkDefault true;
    nix-direnv.enable = lib.mkDefault true;
  };
}
